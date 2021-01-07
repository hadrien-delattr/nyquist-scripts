;nyquist plug-in

;version 3

;type process

;name "Filter with a cutoff ramp"

;action "Filer ramp"

;info "Filter with cutoff ramp by Hadrien Delattre"

; control start-cutoff "cutoff at start" real "Hz" 0 0 50000
; control end-cutoff "cutoff at end" real "Hz" 50000 0 50000

; cutoff difference
(setf cutoff-delta (- end-cutoff start-cutoff))
; duration of selection in seconds
(setf dur (/ len *sound-srate*))
; cutoff ramp
(setf cutoff-ramp (sum start-cutoff (mult cutoff-delta (control-srate-abs *sound-srate* (pwlv 0 1 1)))))
; apply the filter
(lp s cutoff-ramp)
