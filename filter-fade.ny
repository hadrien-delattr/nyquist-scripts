;nyquist plug-in
;version 3
;type process
;name "Filter with a cutoff ramp"
;action "Filer ramp"
;info "Filter with cutoff ramp by Hadrien Delattre"

; control start-cutoff "cutoff at start" real "[Hz]" 0 0 30000
; control end-cutoff "cutoff at end" real "[Hz]" 30000 0 30000
; control filter-type "filter type" choice "lowpass,highpass" 0

; cutoff difference
(setf cutoff-delta (- end-cutoff start-cutoff))
; duration of selection in seconds
(setf dur (/ len *sound-srate*))
; cutoff ramp
(setf cutoff-ramp (sum start-cutoff (mult cutoff-delta (control-srate-abs *sound-srate* (pwlv 0 1 1)))))
; apply the filter
(case filter-type
    (0 (lp s cutoff-ramp))
    (1 (hp s cutoff-ramp))
)
