function! CompileAndRunC()
  " Sauvegarde le fichier courant
  write

  " Chemin complet du fichier courant
  let fullpath = expand('%:p')

  " Nom du fichier sans extension
  let filename = expand('%:r')

  " Chemin du binaire temporaire
  let output = '/tmp/' . filename

  " Commande de compilation
  let cmd = 'cc -Wall -Wextra -Werror ' . shellescape(fullpath) . ' -o ' . shellescape(output) . ' 2>&1'

  " Compile et capture la sortie
  let result = system(cmd)

  " Ouvre un split vertical à droite de largeur 40
  botright vnew
  vertical resize 40
  setlocal buftype=nofile bufhidden=wipe noswapfile

  " Map local pour fermer le split avec Échap
  nnoremap <buffer> <Esc> :q<CR>

  " Si erreur à la compilation
  if v:shell_error != 0
    call setline(1, split(result, "\n"))
    silent! execute 'file ErreurCompilation'
  else
    " Sinon exécute le binaire et affiche la sortie
    let exec_result = system(output)
    call setline(1, split(exec_result == '' ? '<aucune sortie>' : exec_result, "\n"))
    silent! execute 'file RésultatExécution'
  endif
endfunction

" Raccourci F5 pour compiler et exécuter
nnoremap <F5> :call CompileAndRunC()<CR>

