# 💾 `~/.*`
> Dotfiles! Muddafucka!

![In Action](https://github.com/ostera/dotfiles/raw/master/screenshots/Screen%20Shot%202017-03-14%20at%206.22.30%20PM.png)

#### Featuring all of those things that make a fullscreened mac look really cool
* Top-level tmux status bar with _much hacker very code so theme_ theme
* Fuzzy Search and Jump between:
    * tmux sessions/windows [0]
    * recent locations that don't have a window
* tmux+vim awesomesauce
* Ridiculously simple design (read below)
* Other goodies

[0] This alone is so fucking useful that I don't never again have to remember the indexed positions of my session/window/pane combos. I like my computer doing the boring parts for me.

## How They Work

They work fairly simply:

1. Everything starting with a `.` will be symlinked to `~`. That includes:


```
.
|-- git
|   |-- .gitconfig
|   |-- .gitignore_global
|-- shell
|   |-- .alias
|   |-- .ctags
|   |-- .env
|   |-- .kerlrc
|   |-- .path
|   |-- .prompt
|   |-- .racketrc
|   `-- .sbclrc
|-- tmux
|   |-- .tmux.conf
|-- vim
|   |-- .vimrc
`-- zsh
    `-- .zshrc
```

2. The `vim` and `tmux` folders will be linked entirely to `~` since they have some other things (like the `tmux/scripts` I use for my status bar).

![Me showing off my silly status bar](https://github.com/ostera/dotfiles/raw/master/screenshots/Screen%20Shot%202017-03-14%20at%206.11.30%20PM.png)

3. Then there's the install scripts that just run some `brew installs`.

Not much more. Keep it simple. Fork away!

## License

See [LICENSE](https://github.com/ostera/zazen/blob/master/LICENSE).
