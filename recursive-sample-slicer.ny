;nyquist plug-in
;version 3
;type process
;name "Recursive random slicer"
;action "do recursive random slicing"
;info "Recursive random slicer by Hadrien Delattre"

; controls
; control max-depth-power "Maximum recursion depth" int "" 8 1 10
; control recursion-probability "Recursion probability" real "" 0.5 0 1

(setf max-depth (power 2 max-depth-power))
(setf total-length (/ len *sound-srate*))
(setf total-sample (cue s))

; get a random slice of sound at specified depth
(defun get-slice (sound depth)
    (let* (
               (slice-duration (/ total-length depth))
               (slice-index (random depth))
               (start (* slice-duration slice-index))
               (stop (+ start slice-duration))
           )
           (extract-abs start stop sound)
    )
)

(defun chop (sound depth)
    (seq
        (if (and (< depth max-depth) (< (rrandom) recursion-probability))
            ; split the next bit in two
            (let* (
                    ; depth of the two new bits
                    (new-depth (* depth 2))
                )
                (seq
                    (chop sound new-depth)
                    (chop sound new-depth)
                )
            )
            ; just play the next bit
            (get-slice sound depth)
        )
    )
)

(chop total-sample 1)
