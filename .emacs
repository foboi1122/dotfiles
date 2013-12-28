(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

;; Create list of default packages that I want
(defvar jluan/packages '(ecb
			auto-complete
			speedbar
			sr-speedbar
			xcscope
				) "Default packages")

;;Setup and download necessary packages
(require 'cl)
(defun jluan/packages-installed-p ()
  (loop for pkg in jluan/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (jluan/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg jluan/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; Enable winner mode (switch between previous layout settings
(when (fboundp 'winner-mode)
(winner-mode 1))

;interactive do mode
(ido-mode t)

; initialize ecb mode
(require 'ecb)

;; initialize sr-speedbar
(require 'speedbar)

;; auto-complete stuff
(require 'auto-complete-config)
(dolist (m '(c-mode c++-mode java-mode))
  (add-to-list 'ac-modes m))
(ac-config-default)
(global-auto-complete-mode t)

(semantic-mode 1)

(require 'semantic/ia)

;; Semantic
(global-semantic-idle-completions-mode t)
(global-semantic-decoration-mode t)
(global-semantic-highlight-func-mode t)
(global-semantic-show-unmatched-syntax-mode t)

;; Common auto-complete stuff
(add-hook 'c-mode-common-hook '(lambda ()

      ;; ac-omni-completion-sources is made buffer local so
      ;; you need to add it to a mode hook to activate on
      ;; whatever buffer you want to use it with.  This
      ;; example uses C mode (as you probably surmised).

      ;; auto-complete.el expects ac-omni-completion-sources to be
      ;; a list of cons cells where each cell's car is a regex
      ;; that describes the syntactical bits you want AutoComplete
      ;; to be aware of. The cdr of each cell is the source that will
      ;; supply the completion data.  The following tells autocomplete
      ;; to begin completion when you type in a . or a ->

      (add-to-list 'ac-omni-completion-sources
                   (cons "\\." '(ac-source-semantic)))
      (add-to-list 'ac-omni-completion-sources
                   (cons "->" '(ac-source-semantic)))
      (local-set-key (kbd "<f12>") 'semantic-ia-fast-jump)
      ;; ac-sources was also made buffer local in new versions of
      ;; autocomplete.  In my case, I want AutoComplete to use
      ;; semantic and yasnippet (order matters, if reversed snippets
      ;; will appear before semantic tag completions).

      (setq ac-sources '(ac-source-semantic ac-source-yasnippet))
  ))

;; Link semantic to cscope using xscope
(require 'semantic/scope)
(require 'xcscope)
(cscope-setup)
(require 'semantic/symref)

;;set font
(set-face-attribute 'default nil :family "Anonymous Pro" :height 140)

;;line numbers
(global-linum-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(linum-format (quote "%4d ")))

;;treat .h files at C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; use F5 as compile
(global-set-key [(f5)] 'compile)

;; make compilation window smaller
(setq compilation-window-height 8)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(semantic-tag-boundary-face ((t nil)))
 '(semantic-unmatched-syntax-face ((t (:underline nil)))))

;; Make sure my meta keys are mapped right
(add-hook 'term-setup-hook
  '(lambda ()
     (define-key function-key-map "\e[1;9A" [M-up])
     (define-key function-key-map "\e[1;9B" [M-down])
     (define-key function-key-map "\e[1;9C" [M-right])
     (define-key function-key-map "\e[1;9D" [M-left])))
