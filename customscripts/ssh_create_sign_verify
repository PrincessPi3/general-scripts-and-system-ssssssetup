#!/bin/bash
#
# SSH File Signing Tool
# Purpose: Creates cryptographic signatures for files using SSH keys with dual-layer verification
# Dependencies: cracklib-runtime, openssh-client(s)
# Author: [Your name]
# Date: $(date +%Y-%m-%d)
#
# Features:
#   - SSH signature verification using private key
#   - Salted SHA256/SHA512 checksums for independent verification
#   - Enforces strong 50+ character passphrases via cracklib
#   - Creates complete verification package with instructions
#

# Debug mode (uncomment to enable)
# set -x

# Shell safety options
set -Eeuo pipefail  # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # Safe field splitting (newline and tab only)
trap 'error_handler $?' ERR  # Trap errors and call error handler

# ============================================================================
# HELP AND USAGE
# ============================================================================

show_help() {
    cat << EOF
SSH File Signing Tool - Cryptographic File Signature Generator

Creates cryptographic signatures for files using SSH keys with dual-layer verification:
  1. SSH signature using private key (cryptographic proof)
  2. Salted checksums for independent verification (passphrase-based)

Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help    Show this help message and exit

Features:
  • Generates ed25519 (or other) SSH key pair with strong passphrase
  • Creates detached signatures for files using SSH signing
  • Generates normal and salted SHA256/SHA512 checksums
  • Creates complete verification package with public key and instructions
  • Enforces strong 50+ character passphrases validated by cracklib
  • Two independent verification methods (key-based and passphrase-based)

Output:
  Creates a public_files directory containing:
    - Signed file
    - Signature files (.sig)
    - Checksums file with normal and salted hashes
    - Public key and allowed_signers file
    - Verification instructions

Security:
  • Private key protected with unique 50+ character passphrase
  • Checksum salt uses different 50+ character passphrase
  • Both passphrases must pass cracklib security checks
  • Passphrases cleared from memory after use

EOF
    exit 0
}

# Parse command-line arguments
if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
    show_help
fi

# ============================================================================
# CONFIGURATION AND CONSTANTS
# ============================================================================

# Default values (can be overridden during execution)
default_email="anonymous@anonymous.com"
default_algo="ed25519"
default_working_dir="$PWD"
default_key_name="Signing_Key_$default_algo"
default_public_files_dir_name="public_files"
txt_help_file_name="How_to_Verify_Files.txt"

# ANSI color codes for output formatting
RED='\033[0;31m'     # Error messages
GREEN='\033[0;32m'   # Success messages
BLUE='\033[0;34m'    # Section headers
YELLOW='\033[0;33m'  # Warnings
NO_COLOR='\033[0m'   # Reset color

# ============================================================================
# ERROR HANDLING
# ============================================================================

error_handler() {
    local retcode="$1"
    echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
    echo -e "${RED}ERROR: Command failed with exit code $retcode${NO_COLOR}"
    echo -e "${RED}Line: $BASH_LINENO | Time: ${SECONDS}s | Timestamp: $(date '+%Y-%m-%d %H:%M:%S')${NO_COLOR}"
    echo -e "${RED}Command: $BASH_COMMAND${NO_COLOR}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}\n"
    exit "$retcode"
}

# ============================================================================
# PHASE 1: SYSTEM REQUIREMENTS CHECK
# ============================================================================

echo -e "\n${BLUE}[1/7] Checking System Requirements${NO_COLOR}"

# List of required commands
required_commands=("ssh-keygen" "sha256sum" "sha512sum" "cracklib-check" \
                   "chown" "chmod" "find" "basename" "cat" "mkdir" \
                   "cp" "awk" "readlink" "stat" "du")

# Check for missing commands
missing_commands=()
for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        missing_commands+=("$cmd")
    fi
done

# Exit if any commands are missing
if [ ${#missing_commands[@]} -gt 0 ]; then
    echo -e "${RED}✗ Missing required commands: ${missing_commands[*]}${NO_COLOR}"
    echo -e "${YELLOW}Install missing packages and try again${NO_COLOR}"
    exit 1
fi

echo -e "${GREEN}✓ All required commands available${NO_COLOR}"

# ============================================================================
# PHASE 2: USER INPUT COLLECTION
# ============================================================================

echo -e "\n${BLUE}[2/7] Gathering Configuration${NO_COLOR}"

# Get file to sign
read -p "Enter path to file to sign: " file_to_sign

# Collect SSH key passphrase (hidden input)
read -s -p "Enter unique 50+ character passphrase for SSH key: " ssh_passphrase
echo
read -s -p "Re-enter SSH key passphrase: " ssh_passphrase_check
echo

# Collect checksum verification passphrase (hidden input)
read -s -p "Enter unique 50+ character passphrase for checksum verification: " checksum_passphrase
echo
read -s -p "Confirm checksum verification passphrase: " checksum_passphrase_check
echo

# ============================================================================
# PASSPHRASE VALIDATION
# ============================================================================

# Get passphrase lengths
checksum_passphrase_len=${#checksum_passphrase}
ssh_passphrase_len=${#ssh_passphrase}

# Validate SSH passphrase
if [[ "$ssh_passphrase" != "$ssh_passphrase_check" ]]; then
    echo -e "${RED}✗ SSH passphrases do not match${NO_COLOR}"
    exit 1
fi

if [ $ssh_passphrase_len -lt 50 ]; then
    echo -e "${RED}✗ SSH passphrase must be at least 50 characters (current: $ssh_passphrase_len)${NO_COLOR}"
    exit 1
fi

cracklib_check=$(echo "$ssh_passphrase" | cracklib-check)
if [[ ! "$cracklib_check" =~ OK$ ]]; then
    echo -e "${RED}✗ SSH passphrase not secure enough: $cracklib_check${NO_COLOR}"
    exit 1
fi
echo -e "${GREEN}✓ SSH passphrase validated${NO_COLOR}"

# Validate checksum passphrase
if [[ "$checksum_passphrase" != "$checksum_passphrase_check" ]]; then
    echo -e "${RED}✗ Checksum passphrases do not match${NO_COLOR}"
    exit 1
fi

if [ $checksum_passphrase_len -lt 50 ]; then
    echo -e "${RED}✗ Checksum passphrase must be at least 50 characters (current: $checksum_passphrase_len)${NO_COLOR}"
    exit 1
fi

cracklib_check=$(echo "$checksum_passphrase" | cracklib-check)
if [[ ! "$cracklib_check" =~ OK$ ]]; then
    echo -e "${RED}✗ Checksum passphrase not secure enough: $cracklib_check${NO_COLOR}"
    exit 1
fi

# Ensure the two passphrases are different
if [[ "$checksum_passphrase" == "$ssh_passphrase" ]]; then
    echo -e "${RED}✗ Checksum passphrase MUST be different from SSH passphrase${NO_COLOR}"
    exit 1
fi

echo -e "${GREEN}✓ Checksum passphrase validated${NO_COLOR}"

# Collect optional configuration (press Enter to use defaults)
read -p "Working directory [default: $default_working_dir]: " working_dir
read -p "Email for signatures [default: $default_email]: " email
read -p "Public key comment [default: $default_email]: " comment
read -p "Key algorithm [default: $default_algo]: " algo
read -p "Key filename [default: $default_key_name]: " key_name
read -p "Public files directory name [default: $default_public_files_dir_name]: " public_files_dir_name

# ============================================================================
# PHASE 3: CONFIGURATION VALIDATION
# ============================================================================

echo -e "\n${BLUE}[3/7] Validating Configuration${NO_COLOR}"

# Apply defaults for empty inputs
if [ -z "$working_dir" ]; then
    working_dir="$default_working_dir"
fi

if [ -z "$email" ]; then
    email="$default_email"
fi

if [ -z "$comment" ]; then
    comment="$default_email"
fi

if [ -z "$algo" ]; then
    algo="$default_algo"
fi

if [ -z "$key_name" ]; then
    key_priv_path="$working_dir/$default_key_name"
else
    key_priv_path="$working_dir/$key_name"
fi

if [ -z "$public_files_dir_name" ]; then
    public_files_dir_path="$working_dir/$default_public_files_dir_name"
else
    public_files_dir_path="$working_dir/$public_files_dir_name"
fi

# Validate working directory
if [ ! -d "$working_dir" ]; then
    echo -e "${RED}✗ Working directory does not exist: $working_dir${NO_COLOR}"
    exit 1
fi

if [ ! -w "$working_dir" ]; then
    echo -e "${RED}✗ Working directory is not writable: $working_dir${NO_COLOR}"
    exit 1
fi

cd "$working_dir" || exit 1

# Validate algorithm
valid_algos=("rsa" "ecdsa" "ecdsa-sk" "ed25519" "ed25519-sk" "dsa")
if [[ ! " ${valid_algos[@]} " =~ " ${algo} " ]]; then
    echo -e "${RED}✗ Invalid algorithm '$algo'${NO_COLOR}"
    echo -e "${YELLOW}Valid algorithms: ${valid_algos[*]}${NO_COLOR}"
    exit 1
fi

# Check for existing key files (prevent accidental overwrite)
if [ -f "$key_priv_path" ] || [ -f "$key_priv_path.pub" ]; then
    echo -e "${RED}✗ Key files already exist: $key_priv_path${NO_COLOR}"
    echo -e "${YELLOW}Choose a different key name or remove existing keys${NO_COLOR}"
    exit 1
fi

# Check for existing output directory (prevent accidental overwrite)
if [ -d "$public_files_dir_path" ]; then
    echo -e "${RED}✗ Output directory already exists: $public_files_dir_path${NO_COLOR}"
    echo -e "${YELLOW}Choose a different directory name or remove existing directory${NO_COLOR}"
    exit 1
fi
# Convert to absolute path for consistency
file_to_sign="$(readlink -f "$file_to_sign")"

# Validate file exists
if [ ! -f "$file_to_sign" ]; then
    echo -e "${RED}✗ File not found: $file_to_sign${NO_COLOR}"
    exit 1
fi

# Validate file is readable
if [ ! -r "$file_to_sign" ]; then
    echo -e "${RED}✗ File not readable: $file_to_sign${NO_COLOR}"
    echo -e "${YELLOW}Check file permissions${NO_COLOR}"
    exit 1
fi

# Check file size (warn if > 100MB as entire file is loaded into memory for checksums)
file_size=$(stat -f%z "$file_to_sign" 2>/dev/null || stat -c%s "$file_to_sign" 2>/dev/null || echo 0)
if [ "$file_size" -gt 104857600 ]; then
    file_size_mb=$(( file_size / 1048576 ))
    echo -e "${YELLOW}⚠  Warning: Large file (${file_size_mb}MB) will be loaded into memory${NO_COLOR}"
    read -p "Continue? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Operation aborted by user"
        exit 0
    fi
fi

# Define file paths and extract metadata
file_to_sign_basename="$(basename "$file_to_sign")"
file_size_human="$(du -h "$file_to_sign" 2>/dev/null | cut -f1 || echo 'unknown')"
sig_file_path="$file_to_sign.sig"
key_pub_path="$key_priv_path.pub"
allowed_signers_path="$working_dir/allowed_signers"
file_to_sign_checksums_path="$file_to_sign.checksums"
file_to_sign_checksums_sig_path="$file_to_sign_checksums_path.sig"

# Display validated configuration
echo -e "${GREEN}✓ Configuration validated${NO_COLOR}"
echo -e "  File to sign: $file_to_sign_basename ($file_size_human)"
echo -e "  Algorithm: $algo"
echo -e "  Email: $email"
echo -e "  Working directory: $working_dir"
echo -e "  Output directory: $public_files_dir_path"

# ============================================================================
# PHASE 4: SSH KEY PAIR GENERATION
# ============================================================================

echo -e "\n${BLUE}[4/7] Generating SSH Key Pair${NO_COLOR}"

# Generate SSH key pair with passphrase protection
# Using -N flag to provide passphrase non-interactively
ssh-keygen -t "$algo" -C "$comment" -f "$key_priv_path" -N "$ssh_passphrase" -q 2>/dev/null

# Verify key files were created successfully
if [ ! -f "$key_priv_path" ] || [ ! -f "$key_pub_path" ]; then
    echo -e "${RED}✗ Key generation failed${NO_COLOR}"
    exit 1
fi

echo -e "${GREEN}✓ SSH key pair generated${NO_COLOR}"

# Clear passphrase confirmation variables from memory (security)
unset ssh_passphrase_check
unset checksum_passphrase_check

# Set restrictive permissions on private key (600 = owner read/write only)
chown "$USER:$USER" "$key_priv_path" 2>/dev/null || true
chmod 600 "$key_priv_path"

# Create allowed_signers file (required for SSH signature verification)
pub_key_text="$(cat "$key_pub_path")"
echo "$email $pub_key_text" > "$allowed_signers_path"

# ============================================================================
# PHASE 5: CHECKSUM GENERATION
# ============================================================================

echo -e "\n${BLUE}[5/7] Generating Checksums${NO_COLOR}"

# Load file contents into memory (needed for salted checksums)
file_to_sign_contents="$(cat "$file_to_sign")"

# Generate normal SHA256 and SHA512 checksums
echo -e "sha256 $(sha256sum "$file_to_sign")\nsha512 $(sha512sum "$file_to_sign")" > "$file_to_sign_checksums_path"

# Generate salted SHA256 checksum (passphrase + file contents)
echo -n "sha256 (private salt+\`cat file\`): " >> "$file_to_sign_checksums_path"
echo -n "${checksum_passphrase}${file_to_sign_contents}" | sha256sum | awk '{print $1" "}' >> "$file_to_sign_checksums_path"
echo "$file_to_sign_basename" >> "$file_to_sign_checksums_path"

# Generate salted SHA512 checksum (passphrase + file contents)
echo -n "sha512 (private salt+\`cat file\`): " >> "$file_to_sign_checksums_path"
echo -n "${checksum_passphrase}${file_to_sign_contents}" | sha512sum | awk '{print $1" "}' >> "$file_to_sign_checksums_path"
echo "$file_to_sign_basename" >> "$file_to_sign_checksums_path"

echo -e "${GREEN}✓ Checksums generated (normal + salted)${NO_COLOR}"

# Clear sensitive data from memory
unset file_to_sign_contents
unset checksum_passphrase

# ============================================================================
# PHASE 6: FILE SIGNING AND VERIFICATION
# ============================================================================

echo -e "\n${BLUE}[6/7] Signing Files${NO_COLOR}"

# Sign the original file
echo "$ssh_passphrase" | ssh-keygen -Y sign -f "$key_priv_path" -n file "$file_to_sign" -q 2>/dev/null

if [ ! -f "$sig_file_path" ]; then
    echo -e "${RED}✗ Failed to create signature for $file_to_sign_basename${NO_COLOR}"
    exit 1
fi

# Sign the checksums file
echo "$ssh_passphrase" | ssh-keygen -Y sign -f "$key_priv_path" -n file "$file_to_sign_checksums_path" -q 2>/dev/null

if [ ! -f "$file_to_sign_checksums_sig_path" ]; then
    echo -e "${RED}✗ Failed to create signature for checksums file${NO_COLOR}"
    exit 1
fi

echo -e "${GREEN}✓ Files signed successfully${NO_COLOR}"

# Verify signatures immediately after creation (sanity check)
echo "Verifying signatures..."
if echo "$ssh_passphrase" | ssh-keygen -Y verify -f "$allowed_signers_path" -I "$email" -n file -s "$sig_file_path" < "$file_to_sign" > /dev/null 2>&1; then
    if echo "$ssh_passphrase" | ssh-keygen -Y verify -f "$allowed_signers_path" -I "$email" -n file -s "$file_to_sign_checksums_sig_path" < "$file_to_sign_checksums_path" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Signatures verified successfully${NO_COLOR}"
    else
        echo -e "${RED}✗ Checksums signature verification failed${NO_COLOR}"
        exit 1
    fi
else
    echo -e "${RED}✗ File signature verification failed${NO_COLOR}"
    exit 1
fi

# ============================================================================
# PHASE 7: PUBLIC FILES PACKAGE CREATION
# ============================================================================

echo -e "\n${BLUE}[7/7] Creating Public Files Package${NO_COLOR}"

# Create output directory
mkdir "$public_files_dir_path"

# Copy files to public package
cp "$key_pub_path" "$public_files_dir_path"
cp "$allowed_signers_path" "$public_files_dir_path"
cp "$file_to_sign" "$public_files_dir_path"
cp "$sig_file_path" "$public_files_dir_path"
cp "$file_to_sign_checksums_path" "$public_files_dir_path"
cp "$file_to_sign_checksums_sig_path" "$public_files_dir_path"

# Generate basenames for help text
allowed_signers_path_basename="$(basename "$allowed_signers_path")"
sig_file_path_basename="$(basename "$sig_file_path")"
checksums_sig_file_basename="$(basename "$file_to_sign_checksums_sig_path")"
checksums_file_basename="$(basename "$file_to_sign_checksums_path")"

# Create verification instructions file
help_txt="To Verify Signatures (Linux):\n\tssh-keygen -Y verify -f \"$allowed_signers_path_basename\" -I \"$email\" -n file -s \"$sig_file_path_basename\" < \"$file_to_sign_basename\"\n\tssh-keygen -Y verify -f \"$allowed_signers_path_basename\" -I \"$email\" -n file -s \"$checksums_sig_file_basename\" < \"$checksums_file_basename\"\n\nTo Verify Normal Checksums (Linux):\n\tsha256sum $file_to_sign_basename\n\tsha512sum $file_to_sign_basename\n\t\tThen compare to values in $checksums_file_basename\n\nTo Verify Authenticated Checksums Via Private Salt (Linux):\n\tprivate_salt=\"<PROVIDED SALT HERE>\"\n\techo -n \"\${private_salt}\$(cat $file_to_sign_basename)\" | sha256sum\n\techo -n \"\${private_salt}\$(cat $file_to_sign_basename)\" | sha512sum\n\t\tThen compare to values in $checksums_file_basename"
echo -e "$help_txt" > "$public_files_dir_path/$txt_help_file_name"

echo -e "${GREEN}✓ Public files package created${NO_COLOR}"

# ============================================================================
# COMPLETION SUMMARY
# ============================================================================

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"
echo -e "${GREEN}✓ Operation Completed Successfully${NO_COLOR}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NO_COLOR}"

echo -e "\n${BLUE}Public Files Package:${NO_COLOR} $public_files_dir_path"
echo -e "  • $file_to_sign_basename (signed file)"
echo -e "  • $sig_file_path_basename (file signature)"
echo -e "  • $checksums_file_basename (checksums file)"
echo -e "  • $checksums_sig_file_basename (checksums signature)"
echo -e "  • $allowed_signers_path_basename (allowed signers list)"
echo -e "  • $(basename "$key_pub_path") (public key)"
echo -e "  • $txt_help_file_name (verification instructions)"

echo -e "\n${YELLOW}Private Files (KEEP SECRET):${NO_COLOR}"
echo -e "  • ${RED}$key_priv_path${NO_COLOR} (private key)"
echo -e "  • ${RED}Checksum passphrase${NO_COLOR} (for independent verification)"

echo -e "\n${GREEN}Next Steps:${NO_COLOR}"
echo -e "  1. Distribute the public files package to recipients"
echo -e "  2. Keep your private key and checksum passphrase secure"
echo -e "  3. Recipients can verify signatures using the instructions file"
echo -e "  4. Optionally provide the checksum passphrase for independent verification\n"

# Final security: clear all passphrases from memory
unset ssh_passphrase