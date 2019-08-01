<?php
/**
 *@package pXP
 *@file ConceptoIngasPro.php
 *@author  (admin)
 *@date 07-03-2019 13:53:18
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConceptoIngasDetPro={
        require:'../../../sis_parametros/vista/concepto_ingas_det/ConceptoIngasDet.php',
        requireclase:'Phx.vista.ConceptoIngasDet',
        title:'Concepto Ingreso/Gasto Det',
        nombreVista: 'ConceptoIngasDetPro',
        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.ConceptoIngasDetPro.superclass.constructor.call(this,config);

            this.init();

            this.bloquearMenus();
        },
        onButtonNew:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            Phx.vista.ConceptoIngasDetPro.superclass.onButtonNew.call(this);
            this.Cmp.agrupador.setValue('no');
            this.Cmp.id_concepto_ingas_det_fk.store.baseParams.id_concepto_ingas = this.maestro.id_concepto_ingas;
        },
        onButtonEdit:function(){
            var rec = this.getSelectedData();
            console.log('rec',rec);
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            Phx.vista.ConceptoIngasDetPro.superclass.onButtonEdit.call(this);
            this.Cmp.id_concepto_ingas_det_fk.store.baseParams.query = rec.id_concepto_ingas_det_fk;
            this.Cmp.id_concepto_ingas_det_fk.store.load({params:{start:0,limit:50},
                callback : function (r) {
                    if (r.length > 0 ) {

                        this.Cmp.id_concepto_ingas_det_fk.setValue(rec.id_concepto_ingas_det_fk);
                    }

                }, scope : this
            });
        },
        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.ConceptoIngasDetPro.superclass.preparaMenu.call(this,n);
            //this.getBoton('diagrama_gantt').enable();
            return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.ConceptoIngasDetPro.superclass.liberaMenu.call(this);
            if(tb){
                //this.getBoton('btnChequeoDocumentosWf').disable();

            }
            return tb
        },
        onReloadPage: function (m) {
            this.maestro = m;
            this.Atributos[this.getIndAtributo('id_concepto_ingas')].valorInicial = this.maestro.id_concepto_ingas;
            this.load({params: {start: 0, limit: 50, nombreVista:this.nombreVista, id_concepto_ingas: this.maestro.id_concepto_ingas, agrupador:'no'}})
        },



    }
    Ext.extend(Phx.vista.ConceptoIngasDetPro,Phx.gridInterfaz,{
        tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
        remoteGroup: true,
        groupField: 'desc_agrupador',
        viewGrid: new Ext.grid.GroupingView({
            forceFit: false,
            // custom grouping text template to display the number of items per group
            //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        }),
        fwidth: 500,
        fheight: 480,

    })
</script>
