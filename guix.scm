;;; SPDX-FileCopyrightText: 2023 Brian Kubisiak <brian@kubisiak.com>
;;;
;;; SPDX-License-Identifier: GPL-3.0-only

(use-modules (gnu packages base)
             (gnu packages python)
             (gnu packages rsync)
             (gnu packages version-control)
             (guix build utils)
             (guix build-system copy)
             (guix gexp)
             ((guix licenses) #:prefix license:)
             (guix packages))

(package
 (name "magpie")
 (version "0.0.0")
 (source (local-file "." "magpie" #:recursive? #t))
 (build-system copy-build-system)
 (arguments
  '(#:phases
    (modify-phases %standard-phases
      (add-after 'install 'patch-input-paths
        (lambda* (#:key inputs outputs #:allow-other-keys)
          (let* ((out (assoc-ref outputs "out"))
                 (bin (string-append out "/bin"))
                 (engines (apply
                           append
                           (map (lambda (engine)
                                  (list
                                   (string-append bin "/magpie-" engine "-init")
                                   (string-append bin "/magpie-" engine "-sync")))
                                '("git" "rsync"))))
                 (PATH
                  (map (lambda (package)
                         (string-append (assoc-ref inputs package) "/bin"))
                       '("coreutils"
                         "diffutils"
                         "findutils"
                         "git"
                         "grep"
                         "rsync"
                         "sed"))))
            (for-each
             (lambda (script)
               (wrap-program script
                 `("PATH" ":" prefix ,PATH)))
             engines)
            (wrap-program (string-append bin "/magpie")
              `("PATH" ":" prefix (,bin)))))))
    #:install-plan '(("magpie" "bin/magpie")
                      ("magpie-git-init" "bin/magpie-git-init")
                      ("magpie-git-sync" "bin/magpie-git-sync")
                      ("magpie-rsync-init" "bin/magpie-rsync-init")
                      ("magpie-rsync-sync" "bin/magpie-rsync-sync"))))
 (inputs
  (list coreutils diffutils findutils git grep python rsync sed))
 (synopsis "Simple scriptable backup script")
 (description "Magpie is a simple backup script that treats data as a set of
channels. Each channel is synchronized with a remote using an engine. Magpie is
designed to be easily extensible to add new engines with different
capabilities.")
 (home-page "https://github.com/velentr/magpie")
 (license license:gpl3))
