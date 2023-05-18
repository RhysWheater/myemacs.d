;; Open emacs frame fullscreen on startup
(setq initial-frame-alist '((left . 0)
			    (top . 33)
			    (width . 1.0)
			    (height . 47)))


(setq inhibit-start-message t)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1)   ; Disable the toolbar
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room
(menu-bar-mode -1)   ; Disable the menu bar

;(set-face-attribute 'default nil :font "Fira Code Retina" :height 280)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Initialize package sources
(require 'use-package)

(setq use-package-always-ensure t)
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
	     :hook (prog-mode . rainbow-delimiters-mode))

(use-package command-log-mode)

(use-package ivy
	     :diminish
	     :bind (("C-s" . swiper)
		    :map ivy-minibuffer-map
		    ("TAB" . ivy-alt-done)
		    ("C-l" . ivy-alt-done)
		    ("C-j" . ivy-next-line)
		    ("C-k" . ivy-previous-line)
		    :map ivy-switch-buffer-map
		    ("C-k" . ivy-previous-line)
		    ("C-l" . ivy-done)
		    ("C-d" . ivy-switch-buffer-kill)
		    :map ivy-reverse-i-search-map
		    ("C-k" . ivy-previous-line)
		    ("C-d" . ivy-reverse-i-search-kill))
	     :config
	     (ivy-mode 1))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

(use-package doom-modeline
	     :ensure t
	     :init (doom-modeline-mode 1)
	     :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :init (load-theme 'doom-monokai-spectrum t))

(use-package which-key
	     :init (which-key-mode)
	     :diminish which-key-mode
	     :config
	     (setq which-key-idle-delay 0))

(use-package ivy-rich
	     :init
	     (ivy-rich-mode 1))

(use-package counsel
	     :bind (("M-x" . counsel-M-x)
		    ("C-x b" . counsel-ibuffer)
		    ("C-x C-f" . counsel-find-file)
		    :map minibuffer-local-map
		    ("C-r" . 'counsel-minibuffer-history))
	     :config
	     (setq ivy-initial-inputs-alist nil))

(use-package helpful
	     :ensure t
	     :custom
	     (counsel-describe-function-function #'helpful-callable)
	     (counsel-describe-variable-function #'helpful-variable)
	     :bind
	     ([remap describe-function] . counsel-describe-function)
	     ([remap describe-command] . helpful-command)
	     ([remap describe-variable] . counsel-describe-variable)
	     ([remap describe-key] . helpful-key))

;(use-package general
;  :config
;  (general-create-definer rune/leader-keys
;    :keymaps '(normal insert visual emacs)
;    :prefix "SPC"
;    :global-prefix "C-SPC")
;  (rune/leader-keys
;    "t" '(:ignore t :which-key "toggles")
;    "tt" '(counsel-load-theme :which-key "choose theme")))

(general-define-key
 "<escape>" 'keyboard-escape-quit) ; Make ESC quit prompts

(defun rune/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :hook (evil-mode . rune/evil-hook)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
(evil-mode 1) ; For some reason calling this in :config isn't working
