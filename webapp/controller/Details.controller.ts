import BusyIndicator from "sap/ui/core/BusyIndicator";
import Controller from "sap/ui/core/mvc/Controller";
import ODataModel from "sap/ui/model/odata/v2/ODataModel";
import UpdateMethod from "sap/ui/model/odata/UpdateMethod";
import SmartTable from "sap/ui/comp/smarttable/SmartTable";
import Button from "sap/m/Button";
import ManagedObject from "sap/ui/base/ManagedObject";
import Filter from "sap/ui/model/Filter";
import FilterOperator from "sap/ui/model/FilterOperator";
import Dialog from "sap/m/Dialog";
import DateFormat from "sap/ui/core/format/DateFormat";
import Input from "sap/m/Input";

export default class Details extends Controller {


    public oDataModel: ODataModel;
    public gateEntry: any = {};
    public outDialog: Dialog;


    public onInit(): void {
        let oRouter = (this.getOwnerComponent() as any).getRouter()
        oRouter.getRoute("GPDetails").attachPatternMatched(this.getDetails, this);
    }

    public getDetails(oEvent: any): void {

        BusyIndicator.show();
        let avcLic = window.decodeURIComponent((<any>oEvent.getParameter("arguments")).GateEntry);

        this.gateEntry = {
            GatePass: avcLic.split("'")[1],
            full: avcLic
        }

        this.oDataModel = new ODataModel("/sap/opu/odata/sap/ZUI_GATEPASS", {
            defaultCountMode: "None",
            defaultUpdateMethod: UpdateMethod.Merge,
        });
        this.oDataModel.setDefaultBindingMode("TwoWay");
        this.getView()!.setModel(this.oDataModel);


        var that = this;
        this.oDataModel.getMetaModel().loaded().then(function () {
            that.byId("smartForm")!.bindElement(avcLic);
            that.byId("_IDGenSmartTable1")!.bindElement("/GatePassLine");
            BusyIndicator.hide();
            // (that.byId("_IDGenSmartTable1") as SmartTable).rebindTable(true);
        });



        this.oDataModel.attachRequestCompleted(function (data: any) {
            let reqDetails = data.getParameters();
            if (reqDetails.url === `GatePass('${that.gateEntry.GatePass}')` && reqDetails.method === 'GET') {
                let headerRes = JSON.parse(data.getParameters().response.responseText).d;
                (that.byId("CancelEntry") as Button).setVisible(!headerRes.VehicleOut && !headerRes.Cancelled);
                (that.byId("Delete") as Button).setVisible(!headerRes.Cancelled && !headerRes.VehicleOut);
            }
        })


    }

    public onBeforeRebindTable(e: any): void {
        var b = e.getParameter("bindingParams"), aDateFilters = [];
        aDateFilters.push(new Filter("GatePass", FilterOperator.EQ, this.gateEntry.GatePass))
        var oOwnMultiFilter = new Filter(aDateFilters, true);
        if (b.filters[0] && b.filters[0].aFilters) {
            var oSmartTableMultiFilter = b.filters[0];
            b.filters[0] = new Filter([oSmartTableMultiFilter, oOwnMultiFilter], true);
        } else {
            b.filters.push(oOwnMultiFilter);
        }
    }

    public onClickVhOut() {
        if (!this.outDialog) this.outDialog = this.byId("_IDGenDialog1") as Dialog;
        this.outDialog.open();
    }

    public onCloseDialog() {
        this.outDialog.close();
    }


    public onClickCancelEntry() {

        this.oDataModel.update(this.gateEntry.full, {
            "Cancelled": true
        }, {
            headers: {
                "If-Match": "*"
            }
        })

    }

    public onClickPost() {
        let that = this;
        var now: any = new Date();

        // Create a date object for today at 12:00 AM
        var midnight: any = new Date(now);
        midnight.setHours(0, 0, 0, 0);

        // Get the difference in milliseconds from midnight
        var msSinceMidnight = now - midnight;
        this.oDataModel.update(this.gateEntry.full, {
            "VehicleOut": true,
            "OutDate": DateFormat.getDateInstance({ pattern: "yyyy-MM-ddTHH:mm:ss" }).format(new Date()),
            "OutTime": { ms: msSinceMidnight, __edmType: 'Edm.Time' },
            "OutMeterReading": (this.byId("idPlantInput") as Input).getValue(),
            "VehOutRemarks":(this.byId("VehOutRemarks") as Input).getValue()
        }, {
            headers: {
                "If-Match": "*"
            },
            success: function () {
                that.outDialog.close();
            }
        })

    }








}



