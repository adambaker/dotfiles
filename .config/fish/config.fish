#
# Fish shell config
#
function g; git $argv; end
function l; ls -lGhp $argv; end
function ll; ls -lAGhp $argv; end
function vi; vim $argv; end
function e; vim $argv; end
function sleep; sudo pm-suspend; end
function pdf; mupdf $argv; end
function img; feh -B black $argv; end

set me (whoami)

set fish_pager_color_description 444
set fish_pager_color_prefix --underline
set fish_pager_color_progress 555
set fish_pager_color_completion ccc

function j
  if test -d ~/src/$argv[1]
    cd ~/src/$argv[1]
  else
    if test -d ~/src/github.com/*/$argv[1]
      cd ~/src/github.com/*/$argv[1]
    end
  end
end

function fish_prompt
  set -l last_status $status
  set -l branch_color
  set -l status_prompt ""
  set -l user_prompt " "
  set -l branch " "

  git diff --cached --quiet HEAD ^&-

  if test $status = 1
    set branch_color green
  else
    set branch_color red
  end

  if test $last_status = 0
    set status_color red
  else
    set status_color yellow
    set status_prompt (set_color red)$last_status(set_color normal)
  end

  if test "$me" != "cloudhead"
    set user_prompt ' '(set_color cyan)$me(set_color normal)' '
  end

  if test -d ".git"
    set branch (set_color -o $branch_color)(__fish_git_branch_prompt)(set_color normal)
  end

  set -l prompt (set_color $status_color)'♡ '(set_color normal)
  set -l now    (set_color red)(date +"%R")(set_color normal)
  echo {$now}{$user_prompt}(prompt_pwd){$branch}{$status_prompt}
  echo $prompt
end


