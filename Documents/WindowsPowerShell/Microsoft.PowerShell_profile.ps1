function dotfile {
    param(
      [Parameter(ValueFromRemainingArguments=$true)]
      $Arguments
    )
    git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $Arguments
}

# Create a function that will edit this file $PROFILE with vim
function edit-profile {
    vim $PROFILE
}
