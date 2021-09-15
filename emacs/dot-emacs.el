;;; sverrest's .emacs file
;;
;; This installs 'use-package' automatically
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Some standard configuration
(if (display-graphic-p)
    (progn
      ;; if graphic
      (setq linum-format "%4d")
      (scroll-bar-mode 0))
  ;; else (optional)
  (menu-bar-mode 0)
  (setq linum-format "%4d\u2502"))

(global-linum-mode t)
(auto-compression-mode t)
(transient-mark-mode 1)       
(fset 'yes-or-no-p 'y-or-n-p)
(display-time)
(column-number-mode t)
(tool-bar-mode 0)

(setq next-line-add-newlines nil
      visible-bell t
      inhibit-startup-screen t
      display-time-24hr-format t
      auth-sources '("~/.authinfo"))

(setq lsp-ui-doc-show-with-cursor nil)
;; (setq gc-cons-threshold (* 100 1024 1024)
;;       read-process-output-max (* 1024 1024)
;;       treemacs-space-between-root-nodes nil
;;       company-idle-delay 0.0
;;       company-minimum-prefix-length 1
;;       lsp-idle-delay 0.1)  ;; clangd is fast

(set-face-attribute 'default nil
		    :font "Inconsolata-17")

(global-set-key (kbd "C-x p") 'previous-multiframe-window)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp helm-xref projectile helm-lsp flycheck magithub lsp-pyright color-theme-modern k8s-mode company-ansible dired-efap yaml-mode ansible-vault ansible-doc ansible yasnippet-snippets lsp-latex dark-souls go-snippets yasnippet go-mode markdown-mode+ mardown-mode+ markdown-toc x company lsp-ui selectrum which-key use-package fill-column-indicator)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package dired-efap :ensure)      ;; edit filename at point
(use-package flycheck :ensure)        ;; find errors on the fly
(use-package magithub :ensure)
(use-package dockerfile-mode :ensure)
(use-package company-ansible :ensure)
(use-package ansible :ensure)
(use-package ansible-doc :ensure)
(use-package ansible-vault :ensure)
(use-package markdown-toc :ensure)
(use-package markdown-mode :ensure)
(use-package yasnippet :ensure)
(use-package yasnippet-snippets :ensure)
(use-package go-snippets :ensure)

;;bells and wistle for the LSP modes
(use-package lsp-treemacs :ensure)
(use-package helm-lsp  :ensure)
(use-package projectile :ensure)
(use-package hydra :ensure)
(use-package avy :ensure)
(use-package which-key :ensure)
(use-package helm-xref :ensure)

;; give a blue horisontal line where it is time to wrap
(use-package fill-column-indicator
  :ensure
  :config
  (setq fill-column 72
	fci-rule-width 1
	fci-rule-color "darkblue")
  (define-globalized-minor-mode global-fci-mode fci-mode
    (lambda () (fci-mode 1)))
  (global-fci-mode 1)
  (hl-line-mode 1))

(use-package yaml-mode
  :ensure
  :config
  (setq company-dabbrev-downcase nil) ; expand camelCase
  (add-hook 'yaml-mode-hook #'ansible))
 
(use-package k8s-mode
 :ensure
 :config
 (setq k8s-search-documentation-browser-function 'browse-url-firefox)
 (add-hook 'k8s-mode #'yas-minor-mode))

;; Work in progress
(use-package dap-mode :ensure) ;; 

(use-package lsp-mode
  :ensure
  :config
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(use-package lsp-ui :ensure)

;; Python LSP need npm installed
(use-package lsp-pyright
  :ensure
  :config
  (add-hook 'python-mode-hook #'yas-minor-mode)
  (add-hook 'python-mode-hook #'lsp-deferred))

;; LSP is using this
(use-package company
  :ensure
  :bind
  (:map company-active-map
        ("C-n". company-select-next)
        ("C-p". company-select-previous)
        ("M-<". company-select-first)
        ("M->". company-select-last))
  ;(:map company-mode-map
  ;      ("<tab>". tab-indent-or-complete)
  ;      ("TAB". tab-indent-or-complete))
  :config
  (setq company-idle-delay 0.3)
  (setq company-minimum-prefix-length 1)
  (global-company-mode t))

;; LSP + golang
;; install gopls for your version of go. I use the dnf version.
(use-package go-mode
  :ensure
  :config
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
  (add-hook 'go-mode-hook #'lsp-deferred)
  (add-hook 'go-mode-hook #'yas-minor-mode))

;; LaTeX
;;cargo install --git https://github.com/latex-lsp/texlab.git --locked
(use-package lsp-latex
  :ensure
  :config
  (add-hook 'latex-mode-hook #'lsp-deferred)
  (add-hook 'latex-mode-hook #'yas-minor-mode))
 
;; bash lsp server is too tough with my $PATH at least :-(
;; (add-hook 'sh-mode-hook #'lsp-deferred)
;; (add-hook 'sh-mode-hook #'yas-minor-mode)

;; Get rid of annoying varaible font size
(set-face-attribute 'lsp-signature-posframe nil :font "Inconsolata-17")
(set-face-attribute 'lsp-signature-face nil :font "Inconsolata-17")
(set-face-attribute 'fixed-pitch-serif nil :font "Inconsolata-17")
(set-face-attribute 'fixed-pitch nil :font "Inconsolata-17")

