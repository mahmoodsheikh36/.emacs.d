;; fix undo-tree package not found error
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; install use-package if not installed
;; package archives
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")
             '("gnu" . "http://elpa.gnu.org/packages/"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; set tabs to 4 spaces, 2 for javascript
(setq-default tab-width 4)
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)
;; set line numbers
(global-linum-mode 1)
;; overwrite highlighted text
(delete-selection-mode 1)
;; show matching parenthases
(show-paren-mode 1)
;; disable upper bars and scrollbar
(menu-bar-mode -1) 
(toggle-scroll-bar -1) 
(tool-bar-mode -1) 
;; always follow symlinks
(setq vc-follow-symlinks t)
;; y-or-n instead of yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)
;; all backups to one folder
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))
;; kill current buffer without prompt
(global-set-key (kbd "C-x k") 'kill-this-buffer)
;; disable new line at the end
;; dunno if the 1st line is necessary
;; (setq mode-require-final-newline nil)
;; (setq require-final-newline nil)
;; disable cursor blink
(blink-cursor-mode 0)
;; treat underscore as part of word
(defun underscore-part-of-word-hook ()
  (modify-syntax-entry ?_ "w"))
(add-hook 'prog-mode-hook 'underscore-part-of-word-hook)
;; kill buffer and window shortcut
(global-set-key (kbd "C-x K") 'kill-buffer-and-window)
;; highlight current line
(global-hl-line-mode)
;; try awesomewm config
(defun try-awesome-config ()
  (interactive)
  (shell-command "Xephyr :5 & sleep 1 ; DISPLAY=:5 awesome"))
;; shortcut to open new eshell buffer
(global-set-key (kbd "C-c s") 'eshell)
;; zap-up-to-char not zap-to-char
(global-set-key (kbd "M-z") 'zap-up-to-char)
;; reload file automatically
(global-auto-revert-mode t)
;; enable all disabled commands
(setq disabled-command-function nil)

(global-set-key (kbd "C-c r") '(lambda () (interactive)
                                 (call-process-shell-command (concat "termite --directory=" (projectile-project-root)) nil 0)))

;; window switching
(defun define-window-switching-keys ()
  (interactive)
  (global-set-key (kbd "C-c C-w l") 'windmove-right)
  (global-set-key (kbd "C-c C-w k") 'windmove-up)
  (global-set-key (kbd "C-c C-w j") 'windmove-down)
  (global-set-key (kbd "C-c C-w h") 'windmove-left))
(define-window-switching-keys)

;; js2-mode as major mode for javascript - disabled some keybindings idk why
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (add-hook 'js2-mode-hook 'js2-mode-hide-warnings-and-errors)
;; (add-hook 'js2-mode-hook 'define-window-switching-keys)

;; shortcuts
(defun open-config-file ()
  (interactive)
  (find-file user-init-file))
(global-set-key (kbd "C-c e") 'open-config-file)
(defun open-awesomewm-config-file ()
  (interactive)
  (find-file "~/workspace/config/awesome/rc.lua"))
(global-set-key (kbd "C-c a") 'open-awesomewm-config-file)

;; handling large files, not very helpful tbh, still slow when loading images
(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) 1000000)
    (message "File is large, entering read-only mode")
    (setq buffer-read-only t)
    (setq-default bidi-display-reordering nil)
    (buffer-disable-undo)))
;; (fundamental-mode)))
(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

;; ;; evil-mode
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; smooth scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don"t accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;; relative numbering
(use-package linum-relative
  :ensure t
  :config
  (linum-relative-mode)
  ;; show current line number not '0'
  (setq linum-relative-current-symbol ""))

;; theme
(setq spacemacs-theme-comment-bg nil)
(setq spacemacs-theme-comment-italic 1)
(setq spacemacs-theme-keyword-italic 1)
(use-package spacemacs-theme
  :ensure t
  :defer t
  :init (load-theme 'spacemacs-dark t))
;; (use-package gruvbox-theme
;;   :ensure t
;;   :config
;;   (load-theme 'gruvbox t))

;; helm
(use-package helm
  :ensure t
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files))

;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (global-set-key (kbd "C-0") 'treemacs-select-window)
  :config
  (treemacs-resize-icons 15)
  (setq treemacs-width 25)
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))
(use-package treemacs-evil
  :after treemacs evil
  :ensure t)
(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)
(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))
(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

;; magit
(use-package magit
  :ensure t)
(use-package evil-magit
  :ensure t
  :config
  (require 'evil-magit))
  ;; (evil-define-key evil-magit-state magit-mode-map "?" 'evil-search-backward))

;; projectile
(use-package projectile
  :ensure t
  :config
  (setq projectile-completion-system 'ivy)
  (setq projectile-project-search-path '("~/workspace/" "~/"))
  (projectile-mode +1)
  ;; (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-globally-ignored-files (append '("*.py" "*.o" "*.so") projectile-globally-ignored-files)))

;; ivy for projectile
(use-package ivy
  :ensure t)

;; eyebrowse for workspaces
(use-package eyebrowse
  :ensure t
  :config
  (eyebrowse-mode t)
  (eyebrowse-setup-opinionated-keys))

;; evil-surround for evil mode
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; fuzzy finder for emacs
(use-package fzf
  :ensure t)

;; vim-like increase and decrease numbers
(use-package evil-numbers
  :ensure t
  :config
  (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
  (global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (global-set-key (kbd "M-/") 'company-complete-common-or-cycle)
  (setq company-idle-delay 0)
  (setq company-require-match nil))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; (use-package evil-collection
;;   :ensure t
;;   :config
;;   (evil-collection-init))

;; dunno if async is useful for me tbh
(use-package async
  :ensure t
  :config
  (autoload 'dired-async-mode "dired-async.el" nil t)
  (dired-async-mode 1)
  (async-bytecomp-package-mode 1))

(use-package lua-mode
  :ensure t
  :config
  (setq lua-indent-level 2))

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode)) ;; enable Emmet's css abbreviation.

(use-package skewer-mode
  :ensure t
  :config
  (add-hook 'js2-mode-hook 'skewer-mode)
  (add-hook 'css-mode-hook 'skewer-css-mode)
  (add-hook 'html-mode-hook 'skewer-html-mode))

(use-package flycheck
  :config
  (global-flycheck-mode))

;; C/C++ packages
(use-package irony
  :ensure t)
(use-package company-irony
  :ensure t)
(use-package flycheck-irony
  :ensure t)
(use-package company-irony-c-headers
  :ensure t)

;; (use-package rainbow-mode
;;   :ensure t)

;; (use-package centaur-tabs
;;   :ensure t
;;   :config
;;   (centaur-tabs-mode t)
;;   :bind
;;   ("C-j" . centaur-tabs-backward)
;;   ("C-k" . centaur-tabs-forward))

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

;; (use-package popwin
;;   :ensure t
;;   :config
;;   (require 'popwin)
;;   (popwin-mode 1)
;;   (push '(dired-mode :position top) popwin:special-display-config)
;;   (push '("*eshell*" :position bottom :stick non-nil) popwin:special-display-config))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
(use-package evil-org
  :ensure t)

(use-package smartparens
  :ensure t)

(use-package lsp-mode
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'lsp))

(use-package company-lsp
  :ensure t)

(use-package lsp-java
  :ensure t)

(use-package lsp-ui
  :ensure t)

(use-package hydra
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; eshell

;; clear command to clear the eshell buffer.
(defun eshell/clear ()
  "Command to clear current eshell buffer."
  (let ((eshell-buffer-maximum-lines 0)) (eshell-truncate-buffer)))
(defun eshell-define-clear-command ()
  "Function to define the command clear in the current mode."
  (defun eshell/clear ()
    (let ((eshell-buffer-maximum-lines 0)) (eshell-truncate-buffer))))
(add-hook 'eshell-load-hook #'eshell-define-clear-command)

;; aliases
(defalias 'e 'find-file)
(defalias 'openo 'find-file-other-window)
(defalias 'try-awesome-config '(shell-command "Xephyr :5 & sleep 1 ; DISPLAY=:5 awesome"))

;; function to refactor json files
(defun beautify-json ()
  "Function to beautify current buffer considering it is in json format."
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "python -mjson.tool" (current-buffer) t)))

;; transparency
 (defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)

;; Set transparency of emacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))
(transparency 95)

;; converting lines to printing statements
(defun convert-line-to-print-statement (print-function-name)
  (interactive)
  (back-to-indentation)
  (insert print-function-name)
  (insert "(")
  (end-of-line)
  (insert ")"))
(defun define-convert-line-to-print-statement (print-function-name)
  (defvar-local my-print-function-name print-function-name)
  (local-set-key (kbd "C-c l") (lambda () (interactive)
                                 (convert-line-to-print-statement my-print-function-name))))

(add-hook 'python-mode-hook (lambda () (interactive)
                              (define-convert-line-to-print-statement "print")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" default)))
 '(package-selected-packages
   (quote
    (spacemacs-theme monokai-theme lsp-ui meghanada lsp-java company-lsp lsp-mode smartparens evil-org org-bullets popwin expand-region company-irony-c-headers flycheck-irony company-irony irony skewer-mode emmet-mode lua-mode rainbow-delimiters company evil-numbers fzf evil-surround eyebrowse ivy evil-magit treemacs-magit treemacs-icons-dired treemacs-projectile treemacs-evil treemacs helm gruvbox-theme linum-relative evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#282828" :foreground "#fdf4c1" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "ADBO" :family "MerriweatherSans-Italic")))))

;; start server
(server-start)