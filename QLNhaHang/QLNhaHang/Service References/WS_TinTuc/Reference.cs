﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QLNhaHang.WS_TinTuc {
    using System.Runtime.Serialization;
    using System;
    
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="BaiViet", Namespace="http://microsoft.com/webservices/")]
    [System.SerializableAttribute()]
    public partial class BaiViet : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string TuaBaiVietField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NoiDungField;
        
        private System.DateTime NgayCapNhatField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LienKetField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false)]
        public string TuaBaiViet {
            get {
                return this.TuaBaiVietField;
            }
            set {
                if ((object.ReferenceEquals(this.TuaBaiVietField, value) != true)) {
                    this.TuaBaiVietField = value;
                    this.RaisePropertyChanged("TuaBaiViet");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=1)]
        public string NoiDung {
            get {
                return this.NoiDungField;
            }
            set {
                if ((object.ReferenceEquals(this.NoiDungField, value) != true)) {
                    this.NoiDungField = value;
                    this.RaisePropertyChanged("NoiDung");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(IsRequired=true, Order=2)]
        public System.DateTime NgayCapNhat {
            get {
                return this.NgayCapNhatField;
            }
            set {
                if ((this.NgayCapNhatField.Equals(value) != true)) {
                    this.NgayCapNhatField = value;
                    this.RaisePropertyChanged("NgayCapNhat");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=3)]
        public string LienKet {
            get {
                return this.LienKetField;
            }
            set {
                if ((object.ReferenceEquals(this.LienKetField, value) != true)) {
                    this.LienKetField = value;
                    this.RaisePropertyChanged("LienKet");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="Exrate", Namespace="http://microsoft.com/webservices/")]
    [System.SerializableAttribute()]
    public partial class Exrate : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CurrencyCodeField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CurrencyNameField;
        
        private double BuyField;
        
        private double TransferField;
        
        private double SellField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false)]
        public string CurrencyCode {
            get {
                return this.CurrencyCodeField;
            }
            set {
                if ((object.ReferenceEquals(this.CurrencyCodeField, value) != true)) {
                    this.CurrencyCodeField = value;
                    this.RaisePropertyChanged("CurrencyCode");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false)]
        public string CurrencyName {
            get {
                return this.CurrencyNameField;
            }
            set {
                if ((object.ReferenceEquals(this.CurrencyNameField, value) != true)) {
                    this.CurrencyNameField = value;
                    this.RaisePropertyChanged("CurrencyName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(IsRequired=true, Order=2)]
        public double Buy {
            get {
                return this.BuyField;
            }
            set {
                if ((this.BuyField.Equals(value) != true)) {
                    this.BuyField = value;
                    this.RaisePropertyChanged("Buy");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(IsRequired=true, Order=3)]
        public double Transfer {
            get {
                return this.TransferField;
            }
            set {
                if ((this.TransferField.Equals(value) != true)) {
                    this.TransferField = value;
                    this.RaisePropertyChanged("Transfer");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(IsRequired=true, Order=4)]
        public double Sell {
            get {
                return this.SellField;
            }
            set {
                if ((this.SellField.Equals(value) != true)) {
                    this.SellField = value;
                    this.RaisePropertyChanged("Sell");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://microsoft.com/webservices/", ConfigurationName="WS_TinTuc.TinTucSoap")]
    public interface TinTucSoap {
        
        // CODEGEN: Generating message contract since element name getBaiVietSoHoaResult from namespace http://microsoft.com/webservices/ is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://microsoft.com/webservices/getBaiVietSoHoa", ReplyAction="*")]
        QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponse getBaiVietSoHoa(QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest request);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://microsoft.com/webservices/getBaiVietSoHoa", ReplyAction="*")]
        System.Threading.Tasks.Task<QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponse> getBaiVietSoHoaAsync(QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest request);
        
        // CODEGEN: Generating message contract since element name getTyGiaResult from namespace http://microsoft.com/webservices/ is not marked nillable
        [System.ServiceModel.OperationContractAttribute(Action="http://microsoft.com/webservices/getTyGia", ReplyAction="*")]
        QLNhaHang.WS_TinTuc.getTyGiaResponse getTyGia(QLNhaHang.WS_TinTuc.getTyGiaRequest request);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://microsoft.com/webservices/getTyGia", ReplyAction="*")]
        System.Threading.Tasks.Task<QLNhaHang.WS_TinTuc.getTyGiaResponse> getTyGiaAsync(QLNhaHang.WS_TinTuc.getTyGiaRequest request);
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getBaiVietSoHoaRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getBaiVietSoHoa", Namespace="http://microsoft.com/webservices/", Order=0)]
        public QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequestBody Body;
        
        public getBaiVietSoHoaRequest() {
        }
        
        public getBaiVietSoHoaRequest(QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute()]
    public partial class getBaiVietSoHoaRequestBody {
        
        public getBaiVietSoHoaRequestBody() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getBaiVietSoHoaResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getBaiVietSoHoaResponse", Namespace="http://microsoft.com/webservices/", Order=0)]
        public QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponseBody Body;
        
        public getBaiVietSoHoaResponse() {
        }
        
        public getBaiVietSoHoaResponse(QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://microsoft.com/webservices/")]
    public partial class getBaiVietSoHoaResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public QLNhaHang.WS_TinTuc.BaiViet[] getBaiVietSoHoaResult;
        
        public getBaiVietSoHoaResponseBody() {
        }
        
        public getBaiVietSoHoaResponseBody(QLNhaHang.WS_TinTuc.BaiViet[] getBaiVietSoHoaResult) {
            this.getBaiVietSoHoaResult = getBaiVietSoHoaResult;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getTyGiaRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getTyGia", Namespace="http://microsoft.com/webservices/", Order=0)]
        public QLNhaHang.WS_TinTuc.getTyGiaRequestBody Body;
        
        public getTyGiaRequest() {
        }
        
        public getTyGiaRequest(QLNhaHang.WS_TinTuc.getTyGiaRequestBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute()]
    public partial class getTyGiaRequestBody {
        
        public getTyGiaRequestBody() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class getTyGiaResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Name="getTyGiaResponse", Namespace="http://microsoft.com/webservices/", Order=0)]
        public QLNhaHang.WS_TinTuc.getTyGiaResponseBody Body;
        
        public getTyGiaResponse() {
        }
        
        public getTyGiaResponse(QLNhaHang.WS_TinTuc.getTyGiaResponseBody Body) {
            this.Body = Body;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.Runtime.Serialization.DataContractAttribute(Namespace="http://microsoft.com/webservices/")]
    public partial class getTyGiaResponseBody {
        
        [System.Runtime.Serialization.DataMemberAttribute(EmitDefaultValue=false, Order=0)]
        public QLNhaHang.WS_TinTuc.Exrate[] getTyGiaResult;
        
        public getTyGiaResponseBody() {
        }
        
        public getTyGiaResponseBody(QLNhaHang.WS_TinTuc.Exrate[] getTyGiaResult) {
            this.getTyGiaResult = getTyGiaResult;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface TinTucSoapChannel : QLNhaHang.WS_TinTuc.TinTucSoap, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class TinTucSoapClient : System.ServiceModel.ClientBase<QLNhaHang.WS_TinTuc.TinTucSoap>, QLNhaHang.WS_TinTuc.TinTucSoap {
        
        public TinTucSoapClient() {
        }
        
        public TinTucSoapClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public TinTucSoapClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public TinTucSoapClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public TinTucSoapClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponse QLNhaHang.WS_TinTuc.TinTucSoap.getBaiVietSoHoa(QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest request) {
            return base.Channel.getBaiVietSoHoa(request);
        }
        
        public QLNhaHang.WS_TinTuc.BaiViet[] getBaiVietSoHoa() {
            QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest inValue = new QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest();
            inValue.Body = new QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequestBody();
            QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponse retVal = ((QLNhaHang.WS_TinTuc.TinTucSoap)(this)).getBaiVietSoHoa(inValue);
            return retVal.Body.getBaiVietSoHoaResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.Threading.Tasks.Task<QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponse> QLNhaHang.WS_TinTuc.TinTucSoap.getBaiVietSoHoaAsync(QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest request) {
            return base.Channel.getBaiVietSoHoaAsync(request);
        }
        
        public System.Threading.Tasks.Task<QLNhaHang.WS_TinTuc.getBaiVietSoHoaResponse> getBaiVietSoHoaAsync() {
            QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest inValue = new QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequest();
            inValue.Body = new QLNhaHang.WS_TinTuc.getBaiVietSoHoaRequestBody();
            return ((QLNhaHang.WS_TinTuc.TinTucSoap)(this)).getBaiVietSoHoaAsync(inValue);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        QLNhaHang.WS_TinTuc.getTyGiaResponse QLNhaHang.WS_TinTuc.TinTucSoap.getTyGia(QLNhaHang.WS_TinTuc.getTyGiaRequest request) {
            return base.Channel.getTyGia(request);
        }
        
        public QLNhaHang.WS_TinTuc.Exrate[] getTyGia() {
            QLNhaHang.WS_TinTuc.getTyGiaRequest inValue = new QLNhaHang.WS_TinTuc.getTyGiaRequest();
            inValue.Body = new QLNhaHang.WS_TinTuc.getTyGiaRequestBody();
            QLNhaHang.WS_TinTuc.getTyGiaResponse retVal = ((QLNhaHang.WS_TinTuc.TinTucSoap)(this)).getTyGia(inValue);
            return retVal.Body.getTyGiaResult;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.Threading.Tasks.Task<QLNhaHang.WS_TinTuc.getTyGiaResponse> QLNhaHang.WS_TinTuc.TinTucSoap.getTyGiaAsync(QLNhaHang.WS_TinTuc.getTyGiaRequest request) {
            return base.Channel.getTyGiaAsync(request);
        }
        
        public System.Threading.Tasks.Task<QLNhaHang.WS_TinTuc.getTyGiaResponse> getTyGiaAsync() {
            QLNhaHang.WS_TinTuc.getTyGiaRequest inValue = new QLNhaHang.WS_TinTuc.getTyGiaRequest();
            inValue.Body = new QLNhaHang.WS_TinTuc.getTyGiaRequestBody();
            return ((QLNhaHang.WS_TinTuc.TinTucSoap)(this)).getTyGiaAsync(inValue);
        }
    }
}
