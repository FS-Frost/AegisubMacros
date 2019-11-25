include("karaskel.lua");

local tr = aegisub.gettext

script_name = tr"Insert text"
script_description = tr"Insert text at the beginning or end of the selected lines."
script_author = "[FS] Frost"
script_version = "1.0.0"

--Elementos de la ventana.
a = {}
a.subtitulos = nil
a.lineas_seleccionadas = nil
a.linea_activa = nil
a.meta = nil
a.estilos = nil
a.config = {
   estilo_nuevo = "",
   estilo_actual = ""
}
a.dialog = {
    {
        class = "label",
        x = 0,
        y = 0,
        height = 1,
        width = 1,
        label = "Text to insert:"
    },
    {
        class = "edit",
        x = 2,
        y = 0,
        height = 1,
        width = 3,
        name = "text",
        hint = "Write the text to insert.",
        value = ""
    },
    {
        class = "label",
        x = 0,
        y = 1,
        height = 1,
        width = 1,
        label = "Insert:"
    },
    {
        class = "dropdown",
        x = 2,
        y = 1,
        height = 1,
        width = 4,
        name = "position",
        items = {"at the beginning","at the end"},
        value = "at the beginning"
    },
}

function a_comenzar(subtitulos, lineas_seleccionadas, linea_activa)
    --Función de inicio (ver última línea).
    a:inicializar(subtitulos, lineas_seleccionadas, linea_activa)
    a:proceso(subtitulos, lineas_seleccionadas, linea_activa)
end

function a:inicializar(subtitulos, lineas_seleccionadas, linea_activa)
    
    --Obteniendo las líneas y selección de Aegisub.
    self.subtitulos = subtitles
    self.lineas_seleccionadas = selected_lineas
    self.linea_activa = active_line
    
    --Obteniendo información del archivo y estilos.
    self.meta, self.estilos = karaskel.collect_head(subtitulos)
    
    --Preparando la ventana.
    self:preparar_ventana()
end

function a:preparar_ventana()
    --Obteniendo configuración.
    local conf  = self.config
end

function a:proceso(subtitulos, lineas_seleccionadas, linea_activa)
    --Mostrando ventana.
    --Información del progreso.
    aegisub.progress.task("Processing...");

    --[[
    "botones" contiene la acción realizada: aceptar o cancelar.
    "resultados" contiene todos los valores de los elementos de la ventana. Se accede a ellos con: resultados[""], con el "name" de cada elemento.
    ]]
    local botones, resultados = aegisub.dialog.display(self.dialog)

    --Obteniendo los resultados individuales.
    local texto = resultados["text"]
    local posicion = resultados["position"]
    
    --Verificando la acción de la ventana.
    if botones then
        --Guardando los resultados.
        self.config = resultados

        --Iniciando la secuencia. Se envían los resultados individuales.
        secuencia(subtitulos, lineas_seleccionadas, linea_activa, texto, posicion)
    else
        aegisub.progress.task("Aborted.");
    end
end

function secuencia(subtitulos, lineas_seleccionadas, linea_activa, texto, posicion)
	--Ciclo de reemplazo sobre las líneas seleccionadas.
    for z, i in ipairs(lineas_seleccionadas) do
		local l = subtitulos[i]
		if posicion == "at the beginning" then
			l.text = texto .. l.text
		else
			l.text = l.text .. texto
		end
		subtitulos[i] = l
	end

    aegisub.progress.task("Finished.")
    aegisub.progress.set(100)

	--Creando punto para deshacer cambios (Ctrl + Z).
    aegisub.set_undo_point(script_name)
end

--Registro de la macro.
aegisub.register_macro(script_name, "", a_comenzar)