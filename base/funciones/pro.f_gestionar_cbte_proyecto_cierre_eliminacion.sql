CREATE OR REPLACE FUNCTION pro.f_gestionar_cbte_proyecto_cierre_eliminacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Proyectos
 FUNCION:       pro.f_gestionar_cbte_proyecto_cierre_eliminacion

 DESCRIPCION:   Esta funcion gestiona la eliminación de los cbtes validados
 AUTOR:         RCM
 FECHA:         24/09/2018
 COMENTARIOS:

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

    v_nombre_funcion        text;
    v_resp                  varchar;
    v_registros             record;
    v_id_estado_actual      integer;
    v_id_proceso_wf         integer;
    v_id_tipo_estado        integer;
    v_id_funcionario        integer;
    v_id_usuario_reg        integer;
    v_id_depto              integer;
    v_codigo_estado         varchar;
    v_id_estado_wf_ant      integer;
    v_reg_cbte              record;
    v_id_proyecto           integer;
    v_cbte                  varchar;

BEGIN

    v_nombre_funcion = 'pro.f_gestionar_cbte_proyecto_cierre_eliminacion';

    ---------------------------------------------------------
    -- Identificación del comprobante que se quiere eliminar
    ---------------------------------------------------------
    select 'uno'::varchar, id_proyecto
    into v_cbte, v_id_proyecto
    from pro.tproyecto
    where id_int_comprobante_1 = p_id_int_comprobante;

    if v_id_proyecto is null then
        select 'dos'::varchar, id_proyecto
        into v_cbte, v_id_proyecto
        from pro.tproyecto
        where id_int_comprobante_2 = p_id_int_comprobante;
    end if;

    if v_id_proyecto is null then
        select 'tres'::varchar, id_proyecto
        into v_cbte, v_id_proyecto
        from pro.tproyecto
        where id_int_comprobante_3 = p_id_int_comprobante;
    end if;

    --Si no encuentra el proyecto se la nza una excepción
    if v_id_proyecto is null then
        raise exception 'El comprobante no está relacionado a ningún Cierre de Proyecto';
    end if;


    ------------------------
    -- Obtención de datos
    ------------------------
    select
    p.id_proyecto,
    p.id_estado_wf_cierre,
    p.id_proceso_wf_cierre,
    p.estado_cierre,
    p.nro_tramite_cierre,
    p.id_int_comprobante_1,
    p.id_int_comprobante_2,
    p.id_int_comprobante_3,
    c.estado_reg as estado_cbte
    into
    v_registros
    from pro.tproyecto p
    inner join conta.tint_comprobante c
    on c.id_int_comprobante = p.id_int_comprobante_1
    where p.id_proyecto = v_id_proyecto;

    -----------------------------------------------------------------
    -- Verifica que ninguno de los 3 comprobantes no estén validados
    -----------------------------------------------------------------
    if exists(select 1 from conta.tint_comprobante
              where (id_int_comprobante = v_registros.id_int_comprobante_1 and estado_reg = 'validado')
              or (id_int_comprobante = v_registros.id_int_comprobante_2 and estado_reg = 'validado')
              or (id_int_comprobante = v_registros.id_int_comprobante_3 and estado_reg = 'validado')) then

        raise exception 'No puede eliminarse el comprobante, alguno de los comprobantes generados ya fue validado';

    end if;

    -----------------------------------
    -- Eliminación de los comprobantes
    -----------------------------------
    --4) Elimina los otros comprobantes generados por la depreciación
    if v_cbte != 'uno' and coalesce(v_registros.id_int_comprobante_1,0)<>0 then
        perform conta.f_cambia_estado_wf_cbte(p_id_usuario, p_id_usuario_ai, p_usuario_ai, v_registros.id_int_comprobante_1, 'eliminado', 'Cbte eliminado');

        --Eliminación de las transacciones
        delete from conta.tint_transaccion
        where id_int_comprobante=v_registros.id_int_comprobante_1;

        --Eliminación del comprobante
        delete from conta.tint_comprobante
        where id_int_comprobante=v_registros.id_int_comprobante_1;

    end if;
    if v_cbte != 'dos' and coalesce(v_registros.id_int_comprobante_2,0)<>0 then
        perform conta.f_cambia_estado_wf_cbte(p_id_usuario, p_id_usuario_ai, p_usuario_ai, v_registros.id_int_comprobante_2, 'eliminado', 'Cbte eliminado');

        --Eliminación de las transacciones
        delete from conta.tint_transaccion
        where id_int_comprobante=v_registros.id_int_comprobante_2;

        --Eliminación del comprobante
        delete from conta.tint_comprobante
        where id_int_comprobante=v_registros.id_int_comprobante_2;
    end if;
    if v_cbte != 'tres' and coalesce(v_registros.id_int_comprobante_3,0)<>0 then
        perform conta.f_cambia_estado_wf_cbte(p_id_usuario, p_id_usuario_ai, p_usuario_ai, v_registros.id_int_comprobante_3, 'eliminado', 'Cbte eliminado');

        --Eliminación de las transacciones
        delete from conta.tint_transaccion
        where id_int_comprobante=v_registros.id_int_comprobante_3;

        --Eliminación del comprobante
        delete from conta.tint_comprobante
        where id_int_comprobante=v_registros.id_int_comprobante_3;

    end if;

    ----------------------------------------------
    -- Cambio del estado del cierre del proyecto
    ----------------------------------------------
    --Recupera estado anterior segun Log del WF
    SELECT
        ps_id_tipo_estado,
        ps_id_funcionario,
        ps_id_usuario_reg,
        ps_id_depto,
        ps_codigo_estado,
        ps_id_estado_wf_ant
    into
        v_id_tipo_estado,
        v_id_funcionario,
        v_id_usuario_reg,
        v_id_depto,
        v_codigo_estado,
        v_id_estado_wf_ant
    FROM wf.f_obtener_estado_ant_log_wf(v_registros.id_estado_wf_cierre);

    --
    select
        ew.id_proceso_wf
    into
        v_id_proceso_wf
    from wf.testado_wf ew
    where ew.id_estado_wf = v_id_estado_wf_ant;
--raise exception 'F: %', (select 1 from conta.tint_comprobante where id_int_comprobante = v_registros.id_int_comprobante_1);
    --Registra el nuevo estado
    v_id_estado_actual = wf.f_registra_estado_wf
                        (
                            v_id_tipo_estado,
                            v_id_funcionario,
                            v_registros.id_estado_wf_cierre,
                            v_id_proceso_wf,
                            p_id_usuario,
                            p_id_usuario_ai,
                            p_usuario_ai,
                            v_id_depto,
                            'Eliminación de comprobantes: '|| COALESCE(v_registros.id_int_comprobante_1::varchar,'NaN')||', '|| COALESCE(v_registros.id_int_comprobante_2::varchar,'NaN')||', '|| COALESCE(v_registros.id_int_comprobante_3::varchar,'NaN')
                        );

    --Actualiza estado de la solicitud
    update pro.tproyecto set
    id_estado_wf_cierre  = v_id_estado_actual,
    estado_cierre        = v_codigo_estado,
    id_usuario_mod       = p_id_usuario,
    fecha_mod            = now(),
    id_int_comprobante_1 = NULL,
    id_int_comprobante_2 = NULL,
    id_int_comprobante_3 = NULL,
    id_usuario_ai        = p_id_usuario_ai,
    usuario_ai           = p_usuario_ai
    where id_proyecto = v_registros.id_proyecto;

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