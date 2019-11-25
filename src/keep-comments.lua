-- Automation 4 demo script
-- Macro that adds \be1 tags in front of every selected line

local tr = aegisub.gettext
local descripcion = "Deja sólo el contenido del primer comentario de las líneas seleccionadas."

script_name = tr"Keep just the comments"
script_description = descripcion
script_author = "[FS] Frost"
script_version = "1.0.0"


function secuencia(subs, lineas_seleccionadas, linea_activa)
	for z, i in ipairs(lineas_seleccionadas) do
		local l = subs[i]
		-- Obtener el inicio del comentario.
		local n1 = string.find(l.text, "{")

		-- Obtener el fin del comentario.
		local n2 = string.find(l.text, "}")
		
		-- Extraer el comentario.
		s = string.sub(l.text, n1+1, n2-1)
		l.text = s
		subs[i] = l
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, descripcion, secuencia)
