function note --description="Take a note in the current notebook"
    if test -z "$argv"
        set title $(read --local --prompt-str "Title of the Note: ")
    else
        set title "$argv"
    end
    
    nb add --title "$title"
end
