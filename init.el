;; (toggle-debug-on-error)
;; disable annoying warnings
(setq native-comp-async-report-warnings-errors nil)
;; disable customization using the interactive interface and remove startup screen
(setq custom-file "/dev/null")
;; disable stupid startup screen
(setq inhibit-startup-screen t)

;; add ~/.emacs.d to load-path and load some files
(push (concat user-emacs-directory "/lisp") load-path)
(require 'setup-constants)
(require 'setup-utils)
(require 'setup-android)
(require 'setup-elpaca)

;; set tab size to 2 spaces except 4 for python
(setq-default ;tab-width 2
              js-indent-level 2
              c-basic-offset 2
              indent-tabs-mode nil
              python-indent-offset 4)
(setq evil-shift-width 2)
;; overwrite highlighted text
(delete-selection-mode 1)
;; show matching parenthases
(show-paren-mode 1)
;; disable upper bars and scrollbar
(when (not (is-android-system))
  ;; (menu-bar-mode -1) ;; enable it so that emacs acts like a normal app on macos
  (when window-system (set-frame-size (selected-frame) 100 50))
  (toggle-scroll-bar -1)
  (tool-bar-mode -1)
  ;; margin around the windows
  ;; (set-fringe-style '(12 . 0))
  (set-fringe-style '(0 . 0))
  )
;; always follow symlinks
(setq vc-follow-symlinks t)
;; y-or-n instead of yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)
;; all backups to one folder
(setq backup-directory-alist `((".*" . ,"~/.emacs.d/backup/"))
      auto-save-file-name-transforms `((".*" ,"~/.emacs.d/backup/" t)))
;; disable cursor blink
(blink-cursor-mode 0)
;; treat underscore as part of word
(defun underscore-part-of-word-hook ()
  (modify-syntax-entry ?_ "w"))
;;(add-hook 'text-mode-hook 'underscore-part-of-word-hook)
;; highlight current line, slows down buffer redisplay, causes cpu spikes like linum-relative
;; (global-hl-line-mode)
;; reload file automatically
(global-auto-revert-mode t)
;; enable all disabled commands
(setq disabled-command-function nil)
;; initial frame size
;; (when window-system (set-frame-size (selected-frame) 120 48))
;; display only buffer name in modeline
;; the following line enables L<line number> at the end
(when (not (is-android-system))
  (setq-default mode-line-format (list " " mode-line-modified "%e %b" mode-line-position-line-format " " '(:eval (persp-current-name)))))
;; (setq-default mode-line-format (list " " mode-line-modified "%e %b"))
;; restore default status line for pdf mode
(let ((hooks '(pdf-view-mode-hook doc-view-mode-hook)))
  (dolist (hook hooks)
    (add-hook hook
              (lambda ()
                (interactive)
                (setq-local mode-line-format (eval (car (get 'mode-line-format 'standard-value))))))))
;; kill buffer without confirmation when its tied to a process
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))
;; make tab complete current word
(setq dabbrev-case-replace nil)
;; (global-set-key "\t" 'dabbrev-completion)
;; save open buffers on exit
;; (desktop-save-mode 1)
;; save minibuffer history
(setq savehist-file (expand-file-name (from-brain "emacs_savehist")))
(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'search-ring)
(add-to-list 'savehist-additional-variables 'regexp-search-ring)
(add-to-list 'savehist-additional-variables 'kill-ring)
(add-to-list 'savehist-additional-variables 'command-history)
(setq history-length t) ;; no limit to history length
;; break long lines into multiple
;;(global-visual-line-mode)
;; stop the annoying warnings from org mode cache
(setq warning-minimum-level :emergency)
;; use imagemagick for formats like webp
(setq image-use-external-converter t)
;; display white spaces and newlines
;; (setq whitespace-style '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark newline-mark missing-newline-at-eof)) ;; use this to highlight everything including space
(setq whitespace-style '(face tabs spaces indentation trailing space-before-tab newline empty space-after-tab tab-mark newline-mark missing-newline-at-eof)) ;; use this to not highlight spaces, works with org better and some themes.. (a fallback)
;; show zero-width characters
(set-face-background 'glyphless-char "red")
;; change newline character
;;(setf (elt (car (cdr (cdr (assoc 'newline-mark whitespace-display-mappings)))) 0) ?⤸)
(global-whitespace-mode)
;; relative line numbers
;; (add-hook 'prog-mode-hook
;;           (lambda ()
;;             (setq display-line-numbers 'relative)))
;; disable annoying local variable prompt
(setq enable-local-variables :all)
;; stop always inserting a newline at the end of a file
(setq require-final-newline nil) ;; not sure if this is needed
(setq mode-require-final-newline nil)
;; dont deactivate the mark on non-shift commands
(setq shift-select-mode 'permanent)
(setq bookmark-file (from-brain "emacs_bookmarks"))
;; (global-highlight-changes-mode)
;; ;; remove highlights after save
;; (add-hook 'after-save-hook
;;           '(lambda()
;;              (if (boundp 'highlight-changes-mode)
;;                  (highlight-changes-remove-highlight (point-min) (point-max)))))
;; return propertized strings from completing-read (when theyre passed) [[denote:20240321T195503][alternative completing read]]
(setq minibuffer-allow-text-properties t)
;; save cursor position of files when you exit them
(save-place-mode 1)
(setq save-place-file (from-brain "emacs_save_place"))
;; disable lock files
(setq create-lockfiles nil)
;; disable stupid beep sounds on macos
(setq ring-bell-function #'ignore)
;; increase max number of messages
(setq message-log-max 100000)
;; dont ask to confirm when opening large files
(setq large-file-warning-threshold nil)
;; disable multiplication precedence over division in calc
(setq calc-multiplication-has-precedence nil)

;; for M-x term
;; (setq explicit-shell-file-name "zsh")
;; (setq shell-file-name "zsh")
;; (setq explicit-zsh-args '("--login" "--interactive"))
;; (setq explicit-zsh-args '("--interactive"))
;; (defun zsh-shell-mode-setup ()
;;   (setq-local comint-process-echoes t))
;; (add-hook 'shell-mode-hook #'zsh-shell-mode-setup)

;; "smooth" scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don"t accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;; start server
;; (server-start)

;; dmenu like functions
(defun search-open-file (directory-path regex)
  "search for file and open it similar to dmenu"
  (interactive)
  (let ((my-file (completing-read "select file: " (directory-files-recursively directory-path regex t))))
    (browse-url (expand-file-name my-file))))

(defun search-open-file-in-emacs (directory-path regex)
  "search for a file recursively in a directory and open it in emacs"
  (let ((my-file (completing-read "select file: " (directory-files-recursively directory-path regex))))
    (find-file (expand-file-name my-file) "'")))

;; eshell configs
;; make the cursor stay at the prompt when scrolling
(setq eshell-scroll-to-bottom-on-input t)
;; file to store aliases automatically to
(setq eshell-aliases-file (from-brain "eshell_aliases"))
(defun eshell-cd-and-ls (&rest args)           ; all but first ignored
  "cd into directory and list its contents"
  (interactive "P")
  (let ((path (car args)))
    (cd path)
    (eshell/ls)))
;; eshell history file location
(setq eshell-history-file-name (from-brain "eshell_history")) ;; save history to filesystem
(setq eshell-history-size 100000000)

;; enable recentf for recently opened file history, https://www.emacswiki.org/emacs/RecentFiles#toc21
(recentf-mode 1)
(setq recentf-max-menu-items 10000000)
(setq recentf-max-saved-items 10000000)

(defun sudo-find-file (file-name)
  "like find file, but opens the file as root using tramp"
  (interactive (list (read-file-name "file: " "/sudo::/")))
  (let ((tramp-file-name (expand-file-name file-name)))
    (find-file tramp-file-name)))

(defun kill-this-buffer-volatile ()
  "kill current buffer, even if it has been modified."
  (interactive)
  (set-buffer-modified-p nil)
  (kill-this-buffer))

;; from xah's website or whatever
(defun copy-file-path (&optional DirPathOnlyQ)
  "copy current buffer file path or dired path.
result is full path.
if `universal-argument' is called first, copy only the dir path.
if in dired, copy the current or marked files.
if a buffer is not file and not dired, copy value of `default-directory'."
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if DirPathOnlyQ
         (progn
           (message "directory copied: %s" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "file path copied: %s" $fpath)
         $fpath)))))

;; from https://www.emacswiki.org/emacs/FindingNonAsciiCharacters
(defun find-first-non-ascii-char ()
  "Find the first non-ascii character from point onwards."
  (interactive)
  (let (point)
    (save-excursion
      (setq point
            (catch 'non-ascii
              (while (not (eobp))
                (or (eq (char-charset (following-char))
                        'ascii)
                    (throw 'non-ascii (point)))
                (forward-char 1)))))
    (if point
        (goto-char point)
      (message "No non-ascii characters."))))
(defun find-next-unsafe-char (&optional coding-system)
  "Find the next character in the buffer that cannot be encoded by
coding-system. If coding-system is unspecified, default to the coding
system that would be used to save this buffer. With prefix argument,
prompt the user for a coding system."
  (interactive "Zcoding-system: ")
  (if (stringp coding-system) (setq coding-system (intern coding-system)))
  (if coding-system nil
    (setq coding-system
          (or save-buffer-coding-system buffer-file-coding-system)))
  (let ((found nil) (char nil) (csets nil) (safe nil))
    (setq safe (coding-system-get coding-system 'safe-chars))
    ;; some systems merely specify the charsets as ones they can encode:
    (setq csets (coding-system-get coding-system 'safe-charsets))
    (save-excursion
      ;;(message "zoom to <")
      (let ((end  (point-max))
            (here (point    ))
            (char  nil))
        (while (and (< here end) (not found))
          (setq char (char-after here))
          (if (or (eq safe t)
                  (< char ?\177)
                  (and safe  (aref safe char))
                  (and csets (memq (char-charset char) csets)))
              nil ;; safe char, noop
            (setq found (cons here char)))
          (setq here (1+ here))) ))
    (and found (goto-char (1+ (car found))))
    found))

;; prettify symbols..
(global-prettify-symbols-mode +1)
;; replace lambda text with symbol
(defconst lisp-prettify-symbols-alist
  '(("lambda"  . ?λ)
    ;; ("let" . ?≜)
    ;; ("nil" . (?· (Br . Bl) ?· (Br . Bl) ?∅))
    ;; ("sqrt" . ?√)
    ;; ("sum" . (?· (Br . Bl) ?· (Br . Bl) ?∑))
    ;; ("equal" . (?· (Br . Bl) ?· (Br . Bl) ?· (Br . Bl) ?· (Br . Bl) ?≡))
    ;; ("defun" . ?⪮)
    ;; ("<=" . ?≤)
    ;; ("<=" . (?· (Br . Bl) ?≤))
    ;; (">=" . (?· (Br . Bl) ?≥))
    ;; ("->" . ?→)
    ;; ("->" . (?· (Br . Bl) ?→))
    ;; ("->>" . (?· (Br . Bl) ?· (Br . Bl) ?↠))
    ;; ("=>" . ?⇒)
    ;; ("map" . (?· (Br . Bl) ?· (Br . Bl) ?↦))
    ;; ("/=" . ?≠)
    ;; ("!=" . ?≠)
    ;; ("==" . ?≡)
    ;; ("<<" . ?≪)
    ;; (">>" . ?≫)
    ;; ("<=<" . ?↢)
    ;; (">=>" . ?↣)
    ;; ("&&" . ?∧)
    ;; ("and" . (?· (Br . Bl) ?· (Br . Bl) ?∧))
    ;; ("or" . (?· (Br . Bl) ?∨))
    ;; ("progn" . ?∘)
    ;; ("not" . (?· (Br . Bl) ?· (Br . Bl) ?¬))
    ))
;; convert back to text when cursor is over the symbol
(setq prettify-symbols-unprettify-at-point 'right-edge)

(defun ascii-table ()
  "display basic ASCII table (0 thru 128)."
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (setq buffer-read-only nil)        ;; Not need to edit the content, just read mode (added)
  (local-set-key "q" 'bury-buffer)   ;; Nice to have the option to bury the buffer (added)
  (save-excursion (let ((i -1))
                    (insert "ASCII characters 0 thru 127.\n\n")
                    (insert " Hex  Dec  Char|  Hex  Dec  Char|  Hex  Dec  Char|  Hex  Dec  Char\n")
                    (while (< i 31)
                      (insert (format "%4x %4d %4s | %4x %4d %4s | %4x %4d %4s | %4x %4d %4s\n"
                                      (setq i (+ 1  i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)))
                      (setq i (- i 96))))))

(defun current-mpv-artist ()
  (shell-command-to-string "sh -c 'echo \"{ \\\"command\\\": [\\\"get_property\\\", \\\"metadata\\\"] }\" | socat - /tmp/mpv_socket | jq -j .data.artist' 2>/dev/null"))

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (common-lisp "https://github.com/theHamsta/tree-sitter-commonlisp")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (csharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (go-mod "https://github.com/camdencheek/tree-sitter-go-mod")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (js . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (lua "https://github.com/Azganoth/tree-sitter-lua")
        (make "https://github.com/alemuller/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (r "https://github.com/r-lib/tree-sitter-r")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; install those grammars
;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))

;; remap some modes to their tree-sitter alternatives, tree-sitter isnt used by default, yet
(dolist (mapping '((python-mode . python-ts-mode)
                   (css-mode . css-ts-mode)
                   (js-mode . js-ts-mode)
                   (typescript-mode . tsx-ts-mode)
                   (json-mode . json-ts-mode)
                   (yaml-mode . yaml-ts-mode)))
  (add-to-list 'major-mode-remap-alist mapping))

;; persistent comint history
;; https://oleksandrmanzyuk.wordpress.com/2011/10/23/a-persistent-command-history-in-emacs/
(defun comint-write-history-on-exit (process event)
  (comint-write-input-ring)
  (let ((buf (process-buffer process)))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (insert (format "\nProcess %s %s" process event))))))
(defun turn-on-comint-history ()
  (let ((process (get-buffer-process (current-buffer))))
    (when process
      (setq comint-input-ring-file-name
            (format "%s/inferior-%s-history"
                    *brain-dir* (process-name process)))
      (comint-read-input-ring)
      (set-process-sentinel process
                            #'comint-write-history-on-exit))))
(defun mapc-buffers (fn)
  (mapc (lambda (buffer)
          (with-current-buffer buffer
            (funcall fn)))
        (buffer-list)))
(defun comint-write-input-ring-all-buffers ()
  (mapc-buffers 'comint-write-input-ring))
(with-eval-after-load 'comint
  (add-hook 'kill-emacs-hook 'comint-write-input-ring-all-buffers)
  (add-hook 'inferior-haskell-mode-hook 'turn-on-comint-history)
  (add-hook 'inferior-python-mode-hook 'turn-on-comint-history)
  (add-hook 'shell-mode-hook 'turn-on-comint-history)
  (add-hook 'kill-buffer-hook 'comint-write-input-ring))

;; load other elisp files
(require 'setup-org)
(require 'setup-packages)
(require 'setup-evil)
(require 'setup-theme)
(require 'setup-dired)
(require 'setup-eglot)
(require 'setup-blk)

(defun insert-random-string (&optional num)
  (interactive)
  (or num (setq num 7))
  (insert (generate-random-string num)))
(global-set-key (kbd "C-c R") #'insert-random-string)

;; open agenda on startup
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (with-eval-after-load-all
             '(evil general)
             (require 'setup-keys)) ;; load setup-org.el
            (when (file-exists-p persp-state-default-file)
              (persp-state-load persp-state-default-file)
              (persp-switch "main"))
            ;; (switch-to-theme 'minimal-light)
            ;; (switch-to-theme 'darktooth-darker)
            ;; (switch-to-theme 'ample-flat)
            ;; (switch-to-theme 'ample-light)
            ;; (switch-to-theme 'ample)
            ;; (switch-to-theme 'acme)
            ;; (switch-to-theme 'doom-gruvbox-light)
            ;; (switch-to-theme 'stimmung-themes-light)
            ;; (switch-to-theme 'stimmung-themes-dark)
            ;; (switch-to-theme 'ef-tritanopia-dark)
            ;; (switch-to-theme 'ef-melissa-dark)

            (switch-to-light-theme)
            ;; (switch-to-theme 'ef-autumn)
            ;; (switch-to-theme 'poet-dark)
            ;; (switch-to-theme 'modus-operandi-tinted)
            ;; (switch-to-theme 'ef-melissa-light)
            ;; (switch-to-theme 'gruvbox-dark-hard)

            ;; (switch-to-theme 'gruvbox-light-soft)
            ;; (switch-to-theme 'modus-operandi)
            ;; (switch-to-theme 'modus-vivendi)
            ;; (switch-to-tango-theme)
            ;; (set-face-background hl-line-face "PeachPuff3")
            ;; (switch-to-theme 'doom-sourcerer)
            ;;(switch-to-darktooth-theme)
            ))
;; enable flyspell (spell checking)
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
;; ;; flyspell buffer when its opened
;; (add-hook 'flyspell-mode-hook #'flyspell-buffer)

;; disable some modes for large files (otherwise emacs will hang..)
;; there's also find-file-literally i guess
(defun conditional-disable-modes ()
  (unless (any #'derived-mode-p '(pdf-view-mode image-mode doc-view-mode archive-mode arc-mode jka-compr-mode))
    (when (> (buffer-size) (* 1024 512))
      (message "entering fundamental-mode from %s" major-mode)
      (flycheck-mode -1)
      (flyspell-mode -1)
      (font-lock-mode -1)
      (fundamental-mode)
      (which-function-mode -1)
      (when (fboundp 'linum-mode) (linum-mode 0))
      (lsp-mode 0)
      )))
(add-hook 'find-file-hook #'conditional-disable-modes)

;; execute some python blocks when a python repl starts
;; (add-hook 'inferior-python-mode-hook (lambda () (notes-execute-marked-src-block (regexp-quote ":python-repl"))))

;; transparency
;; (set-frame-parameter nil 'alpha-background 90)
;; (add-to-list 'default-frame-alist '(alpha-background . 90))

;; http://xahlee.info/emacs/emacs/emacs_file_encoding.html
;; utf-8 as default encoding
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)