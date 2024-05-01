# git-outta-here

I have been frustrated with managing two github profiles on the same machine.

The two approaches I saw either:
1) used `~/.ssh/config` and required a different host to be put in for the repo.
2) used conditional logic in .gitprofile, this felt extremely janky and limited. 

For (2), when I cd'ed into my `~/work`, the git information was misleading because it's not a git repo.

```shell
  ssh -o IdentitiesOnly=yes -i ~/.ssh/keys/id_rsa_work.pub -F /dev/null
```

I think I was also confused by the lack of clarity on which ssh key was being used.

There must be, or should be a simpler way.

In the meantime, I'm happy with this.

`~/.config/git-outta-here.json`
```json
{
  "directories": [
    {
      "path": "/work",
      "config": "~/.gitconfig.work"
    },
    {
      "path": "/*",
      "config": "~/.gitconfig"
    }
  ]
}
```

`git` and `jq` are required.

## Ideas
- ensure that this works with lazygit and other tools.
- add a utility that turns http requests into ssh?
- async git stuff, with queues, for llm ai commits
