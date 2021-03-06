;;; sverrest's .emacs file
;;
;; This installs 'use-package' automagically
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
(setq gc-cons-threshold (* 100 1024 1024)
       read-process-output-max (* 1024 1024)
       treemacs-space-between-root-nodes nil
       company-idle-delay 0.0
       company-minimum-prefix-length 1
       lsp-idle-delay 0.1)
(setq ispell-program-name 'hunspell)

(set-face-attribute 'default nil
		    :font "Inconsolata-17")

(global-set-key (kbd "C-x p") 'previous-multiframe-window)

(use-package dired-efap :ensure)      ;; edit filename at point
(use-package flycheck :ensure)        ;; find errors on the fly
(use-package flycheck-aspell :ensure)
(use-package magithub :ensure)
(use-package dockerfile-mode
  :ensure
  :config
  (setq auto-mode-alist
	(append '(("Dockerfile\\'" . dockerfile-mode)) auto-mode-alist)))
(use-package company-ansible
  :ensure
  :config
  (add-to-list 'company-backends 'company-ansible))
(use-package ansible :ensure)
(use-package ansible-doc :ensure)
(use-package ansible-vault :ensure)
(use-package markdown-toc :ensure)
;; sudo npm i -g unified-language-server
(use-package markdown-mode
  :ensure
  :config
  (add-hook 'markdown-mode-hook #'lsp-deferred)
  )
(use-package yasnippet :ensure)
(use-package yasnippet-snippets :ensure)
(use-package go-snippets :ensure)
(use-package dns-mode
  :ensure
  :config
  (setq auto-mode-alist
	(append '(("\\ik/dns/zones\\'" . dns-mode)) auto-mode-alist)))

;;bells and wistle for the LSP modes
(use-package lsp-treemacs :ensure)
(use-package iedit :ensure) ;; edit multiple lines
(use-package helm-lsp  :ensure)
(use-package projectile :ensure)
(use-package hydra :ensure)
(use-package avy :ensure)
(use-package which-key :ensure)
(use-package xref :ensure)
(use-package helm-xref :ensure)
(use-package plantuml-mode
  :ensure
  :config
  (setq plantuml-exec-mode 'executable)
  (setq auto-mode-alist
	(append '(("\\.puml\\'" . plantuml-mode)) auto-mode-alist)))

;; This is messing up LSP
;; give a blue horisontal line where it is time to wrap
;; (use-package fill-column-indicator
;;   :ensure
;;   :config
;;   (setq fill-column 72
;; 	fci-rule-width 1
;; 	fci-rule-color "darkblue")
;;   (define-globalized-minor-mode global-fci-mode fci-mode
;;     (lambda () (fci-mode 1)))
;;   (global-fci-mode 1)
;;   (hl-line-mode 1))

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

(use-package python-mode
  :ensure
  :after dap-mode
  :config
  (setq dap-python-debugger 'debugpy)
  (require 'dap-python))

;; Work in progress
(use-package dap-mode
  :ensure
  :after lsp-mode
  :config
  (setq dap-auto-configure-mode t)
  (require 'dap-ui)
  (dap-tooltip-mode t)
  (tooltip-mode t)
  :init
  (dap-mode 1))

(use-package lsp-mode
  :ensure
  :config
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(use-package lsp-ui
  :ensure
  :after lsp-mode
  :config
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-sideline-update-mode t)
  (setq lsp-ui-peek-enable t)
  (setq lsp-ui-peek-show-directory t)
  (setq lsp-ui-imenu-enable t)
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))

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
  (setq company-idle-delay 0.5)
  (setq company-minimum-prefix-length 1)
  (global-company-mode t))

(use-package company-statistics :ensure)
(use-package company-go :ensure)

;; LSP + golang
;; install gopls for your version of go. I use the dnf version.
;; go install github.com/go-delve/delve/cmd/dlv@latest
(use-package go-mode
  :ensure
  :config
  (require 'dap-go)
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
 
;; bash lsp server is too tough with my $PATH and laptop at least :-(
;; (add-hook 'sh-mode-hook #'lsp-deferred)
;; (add-hook 'sh-mode-hook #'yas-minor-mode)

;; Get rid of annoying varaible font size
(set-face-attribute 'lsp-signature-posframe nil :font "Inconsolata-17")
(set-face-attribute 'lsp-signature-face nil :font "Inconsolata-17")
(set-face-attribute 'fixed-pitch-serif nil :font "Inconsolata-17")
(set-face-attribute 'fixed-pitch nil :font "Inconsolata-17")

(use-package kubernetes :ensure)

; org
(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)
			     (C . t)))

(use-package org-tree-slide
  :ensure
  :config
  (global-set-key (kbd "<f8>") 'org-tree-slide-mode)
  (global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)
)

