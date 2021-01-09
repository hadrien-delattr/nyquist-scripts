; This script generates a chord progression defined by the user.
; To use it, copypaste it in Audacity's Nyquist prompt (Tools > Nyquist prompt)
; set "volume", "dur" and "chords" at your convenience and run the script.
; You may also want to fiddle with the "synth" function.

; controls
(setf volume 0.5)
(setf dur 2) ; chord duration

(setf chords
    (list
        (list e3 g3 b3) ; Em
        (list gf3 a3 b3 ef4) ; B7
        (list g3 c4 e4) ; C 
        (list a3 gf3 d4) ; D
))

(defun synth (freq)
    (scale volume (sum -0.5 (snd-sqrt (hzosc freq))))
)

(defun duration-for-entire-periods (note-freq intended-duration)
    (let* (
            (period-duration (/ 1.0 note-freq))
            (nbof-periods-to-play (round (/ intended-duration period-duration)))
        )
        (* nbof-periods-to-play period-duration)
    )
)

(defun play-chord (time notes chord-length)
    (if (null notes)
        (sim)
        (let* (
                  (note-freq (step-to-hz (car notes)))
                  (actual-dur (duration-for-entire-periods note-freq dur))
            )
            (sim (at (* time actual-dur) (stretch actual-dur (scale (/ volume chord-length) (synth note-freq) )))
            (play-chord time (cdr notes) chord-length))
        )
    )
)

(defun play-chords (time chords)
    (if (null chords)
        (sim)
        (sim (play-chord time (car chords) (length (car chords)))
            (play-chords (+ time 1) (cdr chords))
        )
    )
)

(play-chords 0 chords)
