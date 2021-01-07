;nyquist plug-in
;version 3
;type process
;name "Filter with a cutoff ramp"
;action "Filer ramp"
;info "Filter with cutoff ramp by Hadrien Delattre"

; control start-cutoff "cutoff at start" real "[Hz]" 0 0 30000
; control end-cutoff "cutoff at end" real "[Hz]" 30000 0 30000
; control curve "ramp curve (< 1 = ease-in; 1 = linear; > 1 = ease out)" real "" 1 0.01 10
; control filter-type "filter type" choice "lowpass,highpass" 0

; cutoff difference
(setf cutoff-delta (- end-cutoff start-cutoff))
; duration of selection in seconds
(setf dur (/ len *sound-srate*))
; ramp going from 0 to 1
; explanation: (pwlv 0 1 1) produces a ramp going from 0 to 1; the values of
; this ramp are put to the power "curve" to change the aspect of the ramp.
(setf relative-ramp
    (s-exp
        (mult
            (s-log (pwlv 0 1 1))
            curve)))
; cutoff ramp
(setf cutoff-ramp
    (sum start-cutoff
        (mult cutoff-delta
            (control-srate-abs *sound-srate* relative-ramp))))
; apply the filter
(case filter-type
    (0 (lp s cutoff-ramp))
    (1 (hp s cutoff-ramp))
)
