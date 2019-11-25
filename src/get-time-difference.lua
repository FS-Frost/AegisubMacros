include("karaskel.lua");
clipboard = require 'aegisub.clipboard'

local tr = aegisub.gettext

script_name = "Get time difference"
script_description = "Gets the time difference between two lines."
script_author = "[FS] Frost"
script_version = "1.1.0"

function comenzar(subtitulos, lineas_seleccionadas, linea_activa)
    --Función de inicio (ver última línea).
    inicializar(subtitulos, lineas_seleccionadas, linea_activa)
    proceso(subtitulos, lineas_seleccionadas, linea_activa)
end

function inicializar(subtitulos, lineas_seleccionadas, linea_activa)
    
    --Obteniendo las líneas y selección de Aegisub.
    subtitulos = subtitles
    lineas_seleccionadas = selected_lineas
    linea_activa = active_line
end

function proceso(subtitulos, lineas_seleccionadas, linea_activa)
    --Información del progreso.
    aegisub.progress.task("Processing...");

    --Iniciando la secuencia. Se envían los resultados individuales.
    secuencia(subtitulos, lineas_seleccionadas, linea_activa)
end

function secuencia(subtitulos, lineas_seleccionadas, linea_activa)
	if tabla_tamaño(lineas_seleccionadas) == 2 then
		-- Obteniendo líneas seleccionadas.
		local l1 = subtitulos[lineas_seleccionadas[1]]
		local l2 = subtitulos[lineas_seleccionadas[2]]

		-- Obteniendo diferencia de tiempo de inicio.
		local diferencia = (l1.start_time - l2.start_time) / 1000
		
		-- Obteniendo el valor absoluto.
		if diferencia < 0 then
			diferencia = 0 - diferencia
		end

		-- Dando formato al tiempo.
		local horas = math.modf((diferencia / 3600))
		local minutos = math.modf((((diferencia / 3600) - horas) * 60))
		local segundos = (((((diferencia / 3600) - horas) * 60) - minutos) * 60)
		local ms = (segundos - math.modf(segundos)) * 100
		
		-- Obteniendo segundos sin decimales.
		segundos = math.modf(segundos)
		
		-- Formato de salida: "0:00:00.00"
		local tiempo = string.format("%01d:%02d:%02d.%02d", horas, minutos, segundos, ms)

		local depurar = true
		if depurar then
			--Líneas para depurar.
		aegisub.log("Printing the time difference:")
		mensaje("> Absolute: "..diferencia.." ms")
		mensaje("> Hours: "..horas)
		mensaje("> Minutes: "..minutos)
		mensaje("> Seconds: "..segundos)
		mensaje("> Milliseconds: "..ms)
		mensaje("> Time: "..tiempo)
		end

		-- Dejando el tiempo en el portapapeles.
		clipboard.set(tiempo)
		mensaje("\nTime difference copied to the clipboard.") 

		-- Finalizando.
	    aegisub.progress.task("Finished.")
	    aegisub.progress.set(100)

		--Creando punto para deshacer cambios (Ctrl + Z).
	    aegisub.set_undo_point(script_name)
	end
end

-- Recibe la tabla T e itera sobre ella,
-- aumentando el contador en +1 por cada elemento presente.
function tabla_tamaño(T)
  local contador = 0

  for i in pairs(T) do
  	contador = contador + 1
  end
  
  return contador
end

-- Escribe un mensaje en la ventana de eventos del script.
-- Argumento t: string a escribir.
function mensaje(t)
    aegisub.log("\n" .. t)
end

-- Escribe un mensaje en la ventana de eventos del script.
-- Argumento t: string a escribir.
function mensaje_tabla(t)
    aegisub.log(tableToString(t))
end

-- Devuelve un string con todos los elementos de la tabla.
-- Argumento t: tabla.
function tableToString(t)
    return require 'pl.pretty'.dump(t)
end

--Registro de la macro.
aegisub.register_macro(script_name, script_description, comenzar)