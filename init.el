;;; Emacs package

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
;; keep installed packages in .emacs.d
(setq package-user-dir (concat user-emacs-directory "elpa"))
(package-initialize)
(setq package-enable-at-startup nil)
;; update the package metadata if the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

;; add vendor directory to load path for downloaded elisp files
(add-to-list 'load-path (concat user-emacs-directory "vendor"))

;;; Look and feel

;; load newest byte code
(setq load-prefer-newer t)

;; disable menu bar
(menu-bar-mode -1)

;; disable toolbar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; disable scroll bars
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; disable blinking cursor
(blink-cursor-mode -1)

;; disable bell
(setq ring-bell-function 'ignore)

;; disable startup screen and go to scratch
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; enable line numbers
(global-linum-mode t)

;; line and column number and size
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; show either buffer name if no file is visited
;; or file name with full path
(setq frame-title-format
      '((:eval (if (buffer-file-name)
		   (abbreviate-file-name (buffer-file-name))
		 "%b (%f)"))))

;; don't use tabs for indentation
(setq indent-tabs-mode nil)

;; newline at the end of the file
(setq require-final-newline t)

;; custom directory for backup files (.emacs.d/backups)
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
					       "backups"))))

;; disable autosave mode
(setq auto-save-default nil)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; utf-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; hippie expand configuration
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
	try-complete-file-name-partially
	try-complete-file-name
	try-expand-all-abbrevs
	try-expand-list
	try-expand-line
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol))

;; replace buffer menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; add manual command
(define-key 'help-command (kbd "C-i") 'info-display-manual)

;; enable smart tab behavior
(setq tab-always-indent 'complete)

;; disalbe electric indent mode
(setq electric-indent-mode nil)

;; convert tabs to 2 spaces
(defun die-tabs ()
  "Convert all tabs in buffer to 2 spaces."
  (interactive)
  (set-variable 'tab-width 2)
  (mark-whole-buffer)
  (untabify (region-beginning) (region-end))
  (keyboard-quit))
(global-set-key (kbd "C-c d t") 'die-tabs)

;; shell scripts
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; don't create ~ file
(setq create-lockfiles nil)

;; unlimited undo
(setq undo-limit 9999999)

;; increase font size for better readability
(set-face-attribute 'default nil :height 140)

;; don't pop up font menu on mac
(global-set-key (kbd "s-t") '(lambda () (interactive)))

;; set how emacs yank interacts with operating system
(setq ;; makes killing/yanking interact with the clipboard
      select-enable-clipboard t

      ;; recommended
      select-enable-primary t

      ;; Save clipboard strings into kill ring before replacing them.
      ;; When one selects something in another program to paste it into Emacs,
      ;; but kills something in Emacs before actually pasting it,
      ;; this selection is gone unless this variable is non-nil.
      save-interprogram-paste-before-kill t

      ;; shows all options when running apropos
      apropos-do-all t

      ;; mouse yank commands yank at point instead of at click
      mouse-yank-at-point t)

;; bind some special characters
(global-set-key (kbd "C-x M-l") "λ") ; lambda
(global-set-key (kbd "C-x M-a") "∧") ; and
(global-set-key (kbd "C-x M-o") "∨") ; or
(global-set-key (kbd "C-x M-e") "∈") ; element
(global-set-key (kbd "C-x M-t") "⊤") ; true
(global-set-key (kbd "C-x M-b") "⊥") ; bottom
(global-set-key (kbd "C-x M-f") "∀") ; for all
(global-set-key (kbd "C-x M-e") "∃") ; there exists
(global-set-key (kbd "C-x M-n") "¬") ; negation
(global-set-key (kbd "C-x M-s") "∅") ; empty set
(global-set-key (kbd "C-x M-u") "∪") ; union
(global-set-key (kbd "C-x M-i") "∩") ; intersection

;; bind isearch commands
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)


;;; Package declarations

;; use-package macro for easier package declarations
;; https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-verbose t)

;; zenburn theme
;; https://github.com/bbatsov/zenburn-emacs
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;; highlight matching parentheses
(use-package paren
  :config
  (show-paren-mode 1))

;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode 1))

;; abbrev mode configuration
(use-package abbrev
  :config
  (setq save-abbrevs 'silent)
  (setq-default abbrev-mode t))

;; uniquify mode configuration
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace configuration
(use-package saveplace
  :config
  (setq save-place-file (concat user-emacs-directory "places"))
  (setq-default save-place t))

;; savehist configuration
(use-package savehist
  :config
  (setq savehist-additional-variables
	'(search-ring regexp-search-ring)
	savehist-autosave-interval 120
	savehist-file (concat user-emacs-directory "savehist"))
  (savehist-mode 1))

;; recentf configuration
(use-package recentf
  :config
  (setq recentf-save-file (concat user-emacs-directory ".recentf")
	recentf-max-saved-items 500
	recentf-max-menu-items 15)
  (recentf-mode 1))

;; enable windmove - navigate between visible buffers with shift + arrow
(use-package windmove
  :config
  (windmove-default-keybindings))

;; org mode configuration
(use-package org
  :bind (("C-c a" . 'org-agenda))
  :config
  (setq org-log-done t))

;; lisp mode configuration
(use-package lisp-mode
  :config
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook 'eldoc-mode))

;; ielm configuration
(use-package ielm
  :config
  (add-hook 'ielm-mode-hook 'eldoc-mode)
  (add-hook 'ielm-mode-hook 'rainbow-delimiters-mode))

;; handle lisp expressions easier
(use-package paredit
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'paredit-mode)
  (add-hook 'ielm-mode-hook 'paredit-mode)
  (add-hook 'lisp-mode-hook 'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook 'paredit-mode)
  (add-hook 'scheme-mode-hook 'paredit-mode))

;; clean whitespace on save
(use-package whitespace
  :init
  (add-hook 'before-save-hook '(lambda ()
				 (unless (member major-mode '(gfm-mode))
				   (whitespace-cleanup)))))

;; enable code folding
(use-package hideshow
  :config
  (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
  (add-hook 'lisp-mode-hook 'hs-minor-mode)
  (add-hook 'sh-mode-hook 'hs-minor-mode)
  (add-hook 'web-mode-hook 'hs-minor-mode)
  (add-hook 'lua-mode-hook 'hs-minor-mode))

;; ido allows easier navigation of choices
(use-package ido
  :config
  ;; allow partial matches
  (setq ido-enable-flex-matching t)
  ;; turn off this behavior
  (setq ido-use-filename-at-point nil)
  ;; match only files in current dir
  (setq ido-auto-merge-work-directories-length -1)
  ;; include buffer names of recently open buffers
  (setq ido-use-virtual-buffers t)
  (ido-mode t)
  (ido-everywhere t))

;; enable ido in even more places
;; https://github.com/DarwinAwardWinner/ido-completing-read-plus
(use-package ido-completing-read+
  :ensure t
  :config
  (ido-ubiquitous-mode 1))

;; enhances M-x to allow easier execution of commands
;; https://github.com/nonsequitur/smex
(use-package smex
  :ensure t
  :bind (("M-x" . 'smex))
  :config
  (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  (smex-initialize))

;; char based decision tree navigation
;; https://github.com/abo-abo/avy
(use-package avy
  :ensure t
  :bind (("C-=" . 'avy-goto-char)
	 ("C-|" . 'avy-goto-char-2)
	 ("M-g f" . 'avy-goto-line)
	 ("M-g w" . 'avy-goto-word-1))
  :config
  (setq avy-background t))

;; colorfull parenthesis matching
;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t)

;; colorize color names in buffers
;; https://github.com/emacsmirror/rainbow-mode
(use-package rainbow-mode
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-mode))

;; displays available keybindings
;; https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

;; git integration
;; https://magit.vc
(use-package magit
  :ensure t)

;; project navigation
;; https://github.com/bbatsov/projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode 1))

;; expand region by semantic units
;; https://github.com/magnars/expand-region.el
(use-package expand-region
  :ensure t
  :bind ("C-c C-w" . er/expand-region))

;; slime style navigation
;; https://github.com/purcell/elisp-slime-nav
(use-package elisp-slime-nav
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'elisp-slime-nav-mode)
  (add-hook 'ielm-mode-hook 'elisp-slime-nav-mode))

;; better search and replace
;; https://github.com/syohex/emacs-anzu
(use-package anzu
  :ensure t
  :bind (("M-%" . anzu-query-replace)
	 ("C-M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode 1))

;; makes env variables look like in shell
;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-envs '("PATH"))))

;; move lines up and down
;; https://github.com/emacsfodder/move-text
(use-package move-text
  :ensure t
  :bind
  (([(meta shift up)] . move-text-up)
   ([(meta shift down)] . move-text-down)))

;; clojure integration
;; https://github.com/clojure-emacs/clojure-mode
(use-package clojure-mode
  :ensure t
  :mode (("\\.edn$" . clojure-mode)
	 ("\\.boot$" . clojure-mode))
  :config
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook 'subword-mode)
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))

;; extra syntax highlighting for clojure
;; https://github.com/clojure-emacs/clojure-mode/blob/master/clojure-mode-extra-font-locking.el
(use-package clojure-mode-extra-font-locking
  :ensure t)

;; integration with clojure repl
;; https://github.com/clojure-emacs/cider
(defun cider-switch-to-user-ns ()
  "Set the current repl namespace to user."
  (interactive)
  (cider-repl-set-ns "user"))
(use-package cider
  :ensure t
  :bind (:map clojure-mode-map
	      ("C-c u" . 'cider-switch-to-user-ns))
  :config
  (setq nrepl-log-messages t)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
  ;; go right to the repl buffer when it's finished connecting
  (setq cider-repl-pop-to-buffer-on-connect t)
  ;; when there's a cider error, show its buffer and switch to it
  (setq cider-show-error-buffer t)
  (setq cider-auto-select-error-buffer t)
  ;; where to store the cider history
  (setq cider-repl-history-file (concat user-emacs-directory "cider-history"))
  ;; wrap when navigating history
  (setq cider-repl-wrap-history t))

;; markdown mode
;; https://jblevins.org/projects/markdown-mode/
(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . gfm-mode)
	 ("\\.markdown\\'" . gfm-mode)
	 ("\\.mdown\\'" . gfm-mode))
  :config
  (setq markdown-fontify-code-blocks-natively t))

;; graphviz mode
;; https://github.com/ppareit/graphviz-dot-mode
(use-package graphviz-dot-mode
  :ensure t
  :bind (:map graphviz-dot-mode-map
	 ("C-c b" . 'graphviz-dot-preview)))

;; yaml support
;; https://github.com/yoshiki/yaml-mode
(use-package yaml-mode
  :ensure t)

;; highlight uncommited lines
;; https://github.com/dgutov/diff-hl
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode 1)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; highlight TODO lines
;; https://github.com/tarsius/hl-todo
(use-package hl-todo
  :ensure t
  :config
  (global-hl-todo-mode t))

;; completition mechanism
;; https://github.com/abo-abo/swiper
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

;; alternative to isearch with display
;; https://github.com/abo-abo/swiper
(use-package swiper
  :ensure t
  :bind (("C-c s" . 'swiper)))

;; text completion
;; https://company-mode.github.io
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  ;; Invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows).
  (setq company-tooltip-flip-when-above t)
  (global-company-mode))

;; spell checking - aspell
(use-package flyspell
  :config
  ;; (when (eq system-type 'windows-nt)
    ;; Cygwin provides aspell 0.60+ bin compatible
    ;; with emacs 26+ on Windows. Since whole Cygwin
    ;; bin directory is in path this expression is
    ;; a surplus.
    ;; (add-to-list 'exec-path "C:/usr/cygwin64/bin"))
  ;; use aspell instead of ispell
  (setq ispell-program-name "aspell"
	ispell-extra-args '("--sug-mode=ultra"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode))

;; syntax checking
(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; clojure(script) syntax checker
;; https://github.com/candid82/flycheck-joker
(use-package flycheck-joker
  :ensure t)

;; html, css, xml editing
;; http://web-mode.org
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.css?\\'" . web-mode)
	 ("\\.xml?\\'" . web-mode)
	 ("\\.js?\\'" . web-mode))
  :config
  (add-hook 'web-mode-hook 'subword-mode)
  (add-hook 'web-mode-hook 'tagedit-mode)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t)
  (tagedit-add-paredit-like-keybindings))

;; edit html tags like sexps
;; https://github.com/magnars/tagedit
(use-package tagedit
  :ensure t)

;; lua support
;; http://immerrr.github.io/lua-mode/
(use-package lua-mode
  :ensure t
  :bind (:map lua-mode-map
	      ("C-c C-b" . 'lua-send-buffer)
	      ("C-c C-l" . 'lua-send-current-line)))


;;; Customizations

;; custom.el file
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
