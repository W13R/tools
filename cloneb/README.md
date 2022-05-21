# CloneB

Clones a remote git repo.
This script determines the folder name based on the URL components:

- domain name (e.g. "gitlab.com")
- path (e.g. "/W13R/tools.git")

```
https://gitlab.com/W13R/tools.git -> gitlab.com_W13R_tools.git
```
