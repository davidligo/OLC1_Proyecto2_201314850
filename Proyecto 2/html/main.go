package main
 
import (
	"fmt"// Imprimir en consola
	//"io"// Ayuda a escribir en la respuesta
	"log"//Loguear si algo sale mal
	"net/http"// El paquete HTTP
	"html/template"
)

func prueba(w http.ResponseWriter, r *http.Request){
	template, err := template.ParseFiles("templates/Pruebas2.html")
	if err != nil {
		fmt.Fprintf(w,  "Página no encontrada")
	}else{
		template.Execute(w,nil)
	}
}
 
func main() {
 
	http.HandleFunc("/", prueba)
	direccion := ":3030" // Como cadena, no como entero; porque representa una dirección
	fmt.Println("Servidor listo escuchando en " + direccion)
	log.Fatal(http.ListenAndServe(direccion, nil))
}