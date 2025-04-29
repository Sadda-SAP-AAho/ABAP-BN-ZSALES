import Controller from "sap/ui/core/mvc/Controller";
import Filter from "sap/ui/model/Filter";
import FilterOperator from "sap/ui/model/FilterOperator";
import JSONModel from "sap/ui/model/json/JSONModel";
import ODataModel from "sap/ui/model/odata/v2/ODataModel";

/**
 * @namespace zgatepass.controller
 */
export default class Grid extends Controller {

    public ODataModel: ODataModel;

    /*eslint-disable @typescript-eslint/no-empty-function*/
    public onInit(): void {
        this.ODataModel = new ODataModel("/sap/opu/odata/sap/ZUI_GATEPASS/", {
            defaultCountMode: "None"
        });

        const data = [
            { Name: "Complete" },
            { Name: "Pending" },
            { Name: "All" }
        ];

        let newJsonMode = new JSONModel();
        this.byId("_IDGenSelect1")?.setModel(newJsonMode, "Status");
        newJsonMode.setProperty("/Filter", data);

    }

    public onClickCreate(): void {
        const router = (this.getOwnerComponent() as any).getRouter();
        router.navTo("GPCreate");
    }

    public onBeforeRebindTable(e: any): void {
        var b = e.getParameter("bindingParams"), aDateFilters = [];
        let fromDate = (this.byId("DP3") as any).getValue(),
            toDate = (this.byId("DP2") as any).getValue(),
            Status = (this.byId("_IDGenSelect1") as any).getSelectedItem()?.getText();;
        if (fromDate && toDate) {
            aDateFilters.push(new Filter("EntryDate", FilterOperator.BT, fromDate, toDate))
        }
        else if (fromDate) {
            aDateFilters.push(new Filter("EntryDate", FilterOperator.GT, fromDate))
        }
        else if (toDate) {
            aDateFilters.push(new Filter("EntryDate", FilterOperator.LT, toDate))
        }

        if (Status === 'Pending') {
            aDateFilters.push(
                new Filter("Cancelled", FilterOperator.EQ, false),
                new Filter("VehicleOut", FilterOperator.EQ, false)
            )
        } else if (Status === 'Complete') {
            aDateFilters.push(
                new Filter({
                    filters: [

                        new Filter("Cancelled", FilterOperator.EQ, true),
                        new Filter("VehicleOut", FilterOperator.EQ, true)
                    ],
                    and: false
                })
            )
        }

        if(aDateFilters.length>0){
            var oOwnMultiFilter = new Filter(aDateFilters, true);
            if (b.filters[0] && b.filters[0].aFilters) {
                var oSmartTableMultiFilter = b.filters[0];
                b.filters[0] = new Filter([oSmartTableMultiFilter, oOwnMultiFilter], true);
            } else {
                b.filters.push(oOwnMultiFilter);
            }
        }
    }


    public navigate(oEvt: any): void {
        let sPath = oEvt.getSource().getBindingContext().sPath;
        const router = (this.getOwnerComponent() as any).getRouter();
        router.navTo("GPDetails", {
            GateEntry: window.encodeURIComponent(sPath)
        });
    }

}