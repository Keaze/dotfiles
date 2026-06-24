function jjsync -d "Fetch and rebase current work onto latest trunk"
    jj git fetch; and jj rebase -b @ -d 'trunk()'
end
