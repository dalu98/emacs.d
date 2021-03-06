;;; init-theme.el --- Emacs themes -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Theme configuration.
;;

;;; Code:

;; ---------------------------------------------------------
;; themes
;; ---------------------------------------------------------

(defvar my-dark-theme-alist '(
                               alect-black
                               alect-black-alt
                               alect-dark
                               alect-dark-alt
                               almost-mono-black
                               almost-mono-gray
                               ample
                               ample-flat
                               apropospriate-dark
                               atom-one-dark
                               challenger-deep
                               chocolate
                               cyberpunk
                               darkokai
                               darktooth
                               deeper-blue
                               doom-Iosvkem
                               doom-acario-dark
                               doom-ayu-mirage
                               doom-challenger-deep
                               doom-city-lights
                               doom-dark+
                               doom-dracula
                               doom-ephemeral
                               doom-fairy-floss
                               doom-gruvbox
                               doom-henna
                               doom-homage-black
                               doom-horizon
                               doom-laserwave
                               doom-manegarm
                               doom-material
                               doom-miramare
                               doom-molokai
                               doom-monokai-classic
                               doom-monokai-pro
                               doom-monokai-spectrum
                               doom-moonlight
                               doom-nord
                               doom-nova
                               doom-oceanic-next
                               doom-old-hope
                               doom-one
                               doom-opera
                               doom-outrun-electric
                               doom-palenight
                               doom-peacock
                               doom-plain-dark
                               doom-rouge
                               doom-snazzy
                               doom-solarized-dark
                               doom-sourcerer
                               doom-spacegrey
                               doom-tomorrow-night
                               doom-vibrant
                               doom-wilmersdorf
                               doom-zenburn
                               dracula
                               gotham
                               grandshell
                               green-is-the-new-black
                               gruber-darker
                               gruvbox
                               gruvbox-dark-hard
                               gruvbox-dark-medium
                               gruvbox-dark-soft
                               inkpot
                               jazz
                               kaolin-aurora
                               kaolin-blossom
                               kaolin-bubblegum
                               kaolin-dark
                               kaolin-eclipse
                               kaolin-galaxy
                               kaolin-mono-dark
                               kaolin-ocean
                               kaolin-shiva
                               kaolin-temple
                               kaolin-valley-dark
                               leuven-dark
                               lush
                               manoj-dark
                               material
                               minimal-black
                               misterioso
                               modus-vivendi
                               moe-dark
                               monokai
                               naquadah
                               nimbus
                               nord
                               phoenix-dark-pink
                               sanityinc-solarized-dark
                               sanityinc-tomorrow-blue
                               sanityinc-tomorrow-bright
                               sanityinc-tomorrow-eighties
                               sanityinc-tomorrow-night
                               sinolor-black
                               sinolor-dark
                               sinolor-green
                               sinolor-palace
                               solarized-dark
                               solarized-dark-high-contrast
                               solarized-gruvbox-dark
                               solarized-wombat-dark
                               solarized-zenburn
                               spacegray
                               spacemacs-dark
                               srcery
                               subatomic
                               tango-dark
                               tao-yin
                               tsdh-dark
                               wheatgrass
                               wombat
                               zenburn
                               )
  "Dark themes.")

(defvar my-black-theme-alist '(
                                alect-black
                                alect-black-alt
                                almost-mono-black
                                cyberpunk
                                doom-homage-black
                                grandshell
                                manoj-dark
                                minimal-black
                                modus-vivendi
                                sanityinc-tomorrow-bright
                                sinolor-black
                                wheatgrass
                                )
  "Themes used in the light-less black environment.")

(defvar my-light-theme-alist '(
                                adwaita
                                alect-light
                                alect-light-alt
                                almost-mono-cream
                                almost-mono-white
                                ample-light
                                anti-zenburn
                                apropospriate-light
                                dichromacy
                                doom-acario-light
                                doom-ayu-light
                                doom-flatwhite
                                doom-gruvbox-light
                                doom-homage-white
                                doom-nord-light
                                doom-one-light
                                doom-opera-light
                                doom-plain
                                doom-solarized-light
                                doom-tomorrow-day
                                gruvbox-light-hard
                                gruvbox-light-medium
                                gruvbox-light-soft
                                kaolin-breeze
                                kaolin-light
                                kaolin-mono-light
                                kaolin-valley-light
                                leuven
                                light-blue
                                material-light
                                minimal-light
                                modus-operandi
                                moe-light
                                organic-green
                                parchment
                                sanityinc-solarized-light
                                sanityinc-tomorrow-day
                                sinolor-light
                                solarized-gruvbox-light
                                solarized-light
                                solarized-light-high-contrast
                                spacemacs-light
                                tango
                                tango-plus
                                tao-yang
                                tsdh-light
                                whiteboard
                                )
  "Light themes.")

;; ---------------------------------------------------------
;; variables
;; ---------------------------------------------------------

(defvar my-theme-alist (append my-light-theme-alist my-dark-theme-alist)
  "Total themes.")

(defvar my--fallback-theme 'sinolor-dark
  "Fallback theme if user theme cannot be applied.")

(defvar my--current-theme nil
  "Internal variable storing currently loaded theme.")

(defvar my-current-theme-index 0
  "Mark current theme index.")

(defvar my-cycle-themes (mapcar 'symbol-name my-theme-alist)
  "Get theme names.")

;; ---------------------------------------------------------
;; functions
;; ---------------------------------------------------------

(defun my//cycle-theme (index)
  "According to INDEX cycle through a list of themes among `my-theme-alist'."
  (setq my-current-theme-index
    (+ index (cl-position
               (car (mapcar #'symbol-name my-theme-alist)) my-cycle-themes :test 'equal)))
  (when (>= my-current-theme-index (length my-cycle-themes))
    (setq my-current-theme-index 0))
  (when (< my-current-theme-index 0)
    (setq my-current-theme-index (- (length my-cycle-themes) 1)))
  (let* ((my--current-theme (nth my-current-theme-index my-cycle-themes))
         (progress-reporter
           (make-progress-reporter
             (format "Loading theme %s..." my--current-theme))))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme (intern my--current-theme) t)
    (progress-reporter-done progress-reporter)))

(defun my//random-theme (themes)
  "Pickup random color theme from a list of THEMES.
If want to cycle through self-choose theme, e.g. `my-theme-alist',
then use `(my//random-theme my-theme-alist)'.  If use all available
theme, then use `(my//random-theme (custom-available-themes))'."
  (let* ((available-themes (mapcar 'symbol-name themes))
         (theme (nth (random (length available-themes)) available-themes)))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme (intern theme) t)
    (message "Theme [%s] loaded." theme)))

(provide 'init-theme)

;;; init-theme.el ends here
