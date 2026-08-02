(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages
      '(lsp-mode yasnippet lsp-treemacs helm-lsp helm-xref dune
        projectile hydra flycheck company avy which-key
        zig-mode tuareg ocaml-eglot ocamlformat merlin clang-format disable-mouse nano-theme))

(setq custom-enabled-themes nil)
(load-theme 'nano-light t)

(add-to-list 'exec-path "/home/linuxbrew/.linuxbrew/bin")

(require 'clang-format)
(setq clang-format-style "file")
(setq clang-format-executable "clang-format")

(use-package clang-format
  :ensure t
  :hook ((c-mode . clang-format-on-save-mode)
         (c++-mode . clang-format-on-save-mode))
  :config
  (setq clang-format-style "file"
        clang-format-executable "clang-format"))

(require 'ocamlformat)

(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)

(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)

(add-hook 'c-mode-hook (lambda () (setq-local lsp-enable-formatting nil)))
(add-hook 'c++-mode-hook (lambda () (setq-local lsp-enable-formatting nil)))

(setq lsp-zig-zls-executable "~/.zvm/bin/zls"
      lsp-zig-zig-exe-path "~/.zvm/bin/zig")

(add-hook 'zig-mode-hook
          (lambda ()
            (lsp)
            (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

(use-package tuareg
  :ensure t)

(use-package company
  :ensure t
  :init
  (global-company-mode)
  :custom
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 1))

(use-package eglot
  :ensure t
  :hook (tuareg-mode . eglot-ensure))


(use-package ocamlformat
  :custom (ocamlformat-enable 'enable-outside-detected-project)
  :hook (before-save . ocamlformat-before-save)
  )

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (yas-global-mode))

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      lsp-idle-delay 0.1)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq make-backup-files nil)
(add-to-list 'load-path "~/.config/emacs/lisp/")
(require 'disaster)
(defun disaster-x86 ()
  (interactive)
  (let ((disaster-objdump "objdump -d -S -C"))
    (disaster)))

(defun disaster-arm ()
  (interactive)
  (let ((disaster-objdump "arm-none-eabi-objdump -d -S -C"))
    (disaster)))

(add-hook 'c-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c d") #'disaster-x86)
            (local-set-key (kbd "C-c e") #'disaster-arm)))

(add-hook 'c++-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c d") #'disaster-x86)
            (local-set-key (kbd "C-c e") #'disaster-arm)))
(global-disable-mouse-mode)
