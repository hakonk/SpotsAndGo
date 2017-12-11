package main

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
)

type RuterLine struct {
	Name string `json:"name"`
}

type SpotsLayout struct {
	Span        float32 `json:"span"`
	ItemSpacing float32 `json:"itemSpacing"`
}

type RuterLineArray []RuterLine

type SpotsRuterObject struct {
	Kind   string          `json:"kind"`
	Layout SpotsLayout     `json:"layout"`
	Data   *RuterLineArray `json:"data"`
}

func MakeSpotsStopList(r *RuterLineArray) *SpotsRuterObject {
	layout := SpotsLayout{1.5, 75}
	return &SpotsRuterObject{"list", layout, r}
}

func readJsonStops(w http.ResponseWriter, r *http.Request) {
	response, err := http.Get("https://reisapi.ruter.no/Place/GetStopsByLineID/2")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	data, err2 := ioutil.ReadAll(response.Body)
	if err2 != nil {
		http.Error(w, err2.Error(), http.StatusInternalServerError)
		return
	}
	var stops RuterLineArray
	parseErr := json.Unmarshal(data, &stops)
	if parseErr != nil {
		http.Error(w, parseErr.Error(), http.StatusInternalServerError)
		return
	}
	spotsObject := MakeSpotsStopList(&stops)
	jsonData, jsonErr := json.Marshal(spotsObject)
	if jsonErr != nil {
		http.Error(w, jsonErr.Error(), http.StatusInternalServerError)
		return
	}
	w.Write(jsonData)
	w.Header().Set("Content-Type", "application/json")
}

func main() {
	http.HandleFunc("/v1/renderedStops/", readJsonStops)
	http.ListenAndServe(":8080", nil)
}
