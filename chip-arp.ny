;nyquist plug-in
;version 3
;type generate
;name "Chip Arp"
;action "do chip arp"
;info "Chiptune-style arpeggiator by Hadrien Delattre"

; controls
; control root-string "root note" string "" "c4"
; control arp-string "arpeggio" string "space-separated semitone difference to the root" "0 4 7"
; control dur "notes duration" real "seconds" 0.05 0.001 1
; control repeats "repeats" int "" 4 1 100
; control initial-lp-cutoff "initial LP cutoff" real "[Hz]" 2500 0 30000
; control final-lp-cutoff "final LP cutoff" real "[Hz]" 2500 0 30000
; control initial-volume "initial volume" real "" 1 0 1
; control final-volume "final volume" real "" 1 0 1
; control initial-width "initial pulse bias" real "" 0 -1 1
; control final-width "final pulse bias" real "" 0 -1 1

; code from Steven Jones
; verbatim from 'Harmonic Noise' generator plug-in
; convert input string to semitone-shift list
(defun eval-string-to-list (symname str)
    (let ((form (strcat "(setq " symname " (list " str "))")))
        (eval (read (make-string-input-stream form)))))

; Provided a signal being played at a frequency `note-freq` (Hz) for
; an intended duration `intended-duration` (in seconds),
; this function returns the duration the note should have
; (in seconds) so that the signal's period is not cut.
(defun duration-for-entire-periods (note-freq intended-duration)
    (let* (
            (period-duration (/ 1.0 note-freq))
            (nbof-periods-to-play (round (/ intended-duration period-duration)))
        )
        (* nbof-periods-to-play period-duration)
    )
)

(eval-string-to-list "arp" arp-string)
(setf root (car (eval-string-to-list "foo" root-string)))
(setf arp-length (length arp))
(setf max-i (* repeats arp-length))
(setf width-delta (- final-width initial-width))
(setf lp-cutoff-delta (- final-lp-cutoff initial-lp-cutoff))
(setf volume-delta (- final-volume initial-volume))

(defun arp-seq (i)
    (if (>= i max-i)
        ; if the sequence has reached its end, return an empty seq
        (seq)
        ; if there are still notes to play, continue the sequence
        (seq
            ; the seq has two elements: first is a note
            (let* (
                    (progress (/ (float i) max-i))
                    (note-freq (step-to-hz (+ root (nth (rem i arp-length) arp))))
                    (lp-cutoff (+ initial-lp-cutoff (* progress lp-cutoff-delta)))
                    (volume (+ initial-volume (* progress volume-delta)))
                    (pulse-width (+ initial-width (* progress width-delta)))
                    (note-duration (duration-for-entire-periods note-freq dur))
                    )
                (stretch note-duration (mult (lp (osc-pulse note-freq pulse-width) lp-cutoff) volume))
            )
            ; second is the recursive call
            (arp-seq (+ i 1))
        )
    )
)

(arp-seq 0)
