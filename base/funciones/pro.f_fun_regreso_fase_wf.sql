CREATE OR REPLACE FUNCTION pro.f_fun_regreso_fase_wf (
  p_id_fase integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Sistema
 FUNCION:       pro.f_fun_regreso_fase_wf
                
 DESCRIPCION:   Actualiza los estados despues del registro de un retroceso 
 AUTOR:         EGS
 FECHA:         
 COMENTARIOS: 

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   
 AUTOR:         
 FECHA:         
***************************************************************************/
DECLARE

	v_nombre_funcion          		  text;
    v_resp    				          varchar;
    v_mensaje 				          varchar;
    v_reg_cuenta_doc		          record;
    
BEGIN

	v_nombre_funcion = 'pro.f_fun_regreso_fase_wf';
  
    --Actualiza estado en la solicitud
   
    
     update pro.tfase set 
    id_estado_wf    = p_id_estado_wf,
    estado          = p_codigo_estado,
    id_usuario_mod  = p_id_usuario,
    id_usuario_ai   = p_id_usuario_ai,
    usuario_ai      = p_usuario_ai,
    fecha_mod       = now()                     
    where id_fase = p_id_fase;
    
    return true;

EXCEPTION
					
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;
