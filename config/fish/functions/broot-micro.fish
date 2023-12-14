function broot-micro --description="Select file with broot and open with micro"
    set path $(broot --cmd " toggle_git_ignore" $argv)

    if test -d $path
        broot-micro $path
    else
        micro $path
    end
end
