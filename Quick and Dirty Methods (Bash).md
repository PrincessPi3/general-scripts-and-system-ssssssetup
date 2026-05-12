# Quick and Dirty Methods (Bash)
show every set variale and its value (one liner)
```bash
for v in $(compgen -v); do echo "$v:$$v"; done
```