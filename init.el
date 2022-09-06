(setq package-check-signature nil)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)
(package-install 'use-package)
(setq use-package-always-ensure t)
(require 'use-package)

(require 'cc-mode)

(condition-case nil
		(require 'use-package)
		(file-error
		  (require 'package)
		  (package-initialize)
		  (package-refresh-contents)
		  (package-install 'use-package)))

(package-install 'evil)
(package-install 'js2-mode)

(use-package projectile :ensure t)
(use-package yasnippet :ensure t)
(use-package hydra :ensure t)

(use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration))
  :config (setq lsp-completion-enable-additional-text-edit nil))
(use-package hydra)
(use-package company)
(use-package lsp-ui)
(use-package which-key :config (which-key-mode))
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)
(use-package helm-lsp)
(use-package helm
  :config (helm-mode))
(use-package lsp-treemacs)
(use-package projectile
    :ensure t
    :init (projectile-mode +1)
    :config
    (define-key
        projectile-mode-map
        (kbd "C-c p")
      'projectile-command-map))

(global-set-key (kbd "C-x m") 'eshell)
(use-package magit)

(add-hook 'compilation-filter-hook
          (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

(use-package lsp-mode
    :bind
    (:map lsp-mode-map
          (("\C-\M-b" . lsp-find-implementation)
           ("M-RET" . lsp-execute-code-action))))

(use-package dap-java
  :ensure nil
  :after (lsp-java)

  :config
  (global-set-key (kbd "<f7>") 'dap-step-in)
  (global-set-key (kbd "<f8>") 'dap-next)
  (global-set-key (kbd "<f9>") 'dap-continue))  

(require 'evil)
(evil-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "C-x g") 'magit-status)

(require 'yasnippet)

(use-package editorconfig
	     :ensure t
	     :config 
	     (editorconfig-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package tide :ensure t)
(use-package company :ensure t)
(use-package flycheck :ensure t)

(defun setup-tide-mode ()
    (interactive)
      (tide-setup)
        (flycheck-mode +1)
	  (setq flycheck-check-syntax-automatically '(save mode-enabled))
	    (eldoc-mode +1)
	      (tide-hl-identifier-mode +1)
	        ;; company is an optional dependency. You have to
		  ;; install it separately via package-install
		    ;; `M-x package-install [ret] company`
		      (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'typescript-mode-hook #'setup-tide-mode)

 (require 'web-mode)

  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
                (setup-tide-mode))))

  ;; enable typescript - tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode)
