# git-outta-here

### Why
I have been frustrated with managing two github profiles on the same machine.

### Alternatives
I have stumbled upon a few approaches:
1) using `~/.ssh/config` and maintaining separate hosts for different ssh keys.
```
Host github-work
  HostName github.com
  IdentityFile ~/.ssh/id_rsa_work 

Host github.com
  HostName github.com
  IdentityFile ~/.ssh/id_rsa_personal
```
This requires you to punch in the proper host name when doing anything with ssh. I don't think this is something you should have something to think about.

2) using conditional logic in your `.gitconfig`
```
[includeIf "gitdir:~/personal/"]
  path = ~/.gitconfig-personal
[includeIf "gitdir:~/work/"]
  path = ~/.gitconfig-work
```
I don't like how this behaves. When I `cd` in `~/work`, for example, and log my git config, it won't log my work config because `~/work` has not been initialized in git.
I generally also don't like the syntax.

3) I just found another approach that uses `https://github.com/direnv/direnv`, and exports `GIT_CONFIG_GLOBAL` to your shell. This is very close to the approach this tool is taking. I am also exporting `GIT_CONFIG_GLOBAL` to the shell. This approach is definitely simpler than the approach I'm taking. It doesn't require a git wrapper.

I've only looked through the documentation a little, but one perk of this approach is that you don't need to place `.envrc` files in directories, only a single config file is necessary. However, if a global config file was combined with this approach, there would be no need for multiple `.envrc` and no need for a git wrapper.

Having very little knowledge of ssh and git authentication in general, I found myself confused and frustrated by the behavior where multiple keys were used for authentication.
I use this core ssh command to prevent this behavior.
```shell
  ssh -o IdentitiesOnly=yes -i ~/.ssh/keys/id_rsa_work.pub -F /dev/null

```
### Requirements
`git` and `jq` are required and can both be installed via brew.

### Setup
This currently requires a json config file which is expected at:
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

On macos, the script should be placed at `~/bin/git` if you want to use this over git.
I keep an alias of `ogit` that points to the actual git binary at `/usr/bin/git`, in case this blows up.

I need to investigate: 
`export PATH=path/to/git-plugins/bin:$PATH`

### Ideas
- ensure that this works with lazygit and other tools.
- add a utility that turns http requests into ssh?
- async git stuff, with queues, for llm ai commits
- remove the jq config file, and rely on environment variables.
- simply have this as a tool that allows for pre git commits, and have the 
