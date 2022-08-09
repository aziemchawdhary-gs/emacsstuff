(setq package-check-signature nil)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(require 'package)


(add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

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
(package-install 'helm)

(use-package projectile :ensure t)
(use-package yasnippet :ensure t)
(use-package hydra :ensure t)

(global-set-key (kbd "C-x m") 'eshell)

(require 'evil)
(evil-mode 1)

(require 'helm-config)
(helm-mode 1)

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
