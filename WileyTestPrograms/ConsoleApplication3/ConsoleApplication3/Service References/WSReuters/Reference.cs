﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18444
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ConsoleApplication3.WSReuters {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://ws.rfa.thomsonreuters.com/", ConfigurationName="WSReuters.ConsultaPreciosWS")]
    internal interface ConsultaPreciosWS {
        
        // CODEGEN: Parameter 'return' requires additional schema information that cannot be captured using the parameter mode. The specific attribute is 'System.Xml.Serialization.XmlElementAttribute'.
        [System.ServiceModel.OperationContractAttribute(Action="RequestedRics", ReplyAction="http://ws.rfa.thomsonreuters.com/ConsultaPreciosWS/RequestedRicsResponse")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(obtenerPreciosResponse))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(obtenerPrecios))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(RequestedRicsResponse))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(RequestedRics))]
        [return: System.ServiceModel.MessageParameterAttribute(Name="return")]
        ConsoleApplication3.WSReuters.RequestedRicsResponse1 RequestedRics(ConsoleApplication3.WSReuters.RequestedRicsRequest request);
        
        [System.ServiceModel.OperationContractAttribute(Action="RequestedRics", ReplyAction="http://ws.rfa.thomsonreuters.com/ConsultaPreciosWS/RequestedRicsResponse")]
        System.Threading.Tasks.Task<ConsoleApplication3.WSReuters.RequestedRicsResponse1> RequestedRicsAsync(ConsoleApplication3.WSReuters.RequestedRicsRequest request);
        
        // CODEGEN: Parameter 'return' requires additional schema information that cannot be captured using the parameter mode. The specific attribute is 'System.Xml.Serialization.XmlArrayAttribute'.
        [System.ServiceModel.OperationContractAttribute(Action="http://ws.rfa.thomsonreuters.com/ConsultaPreciosWS/obtenerPreciosRequest", ReplyAction="http://ws.rfa.thomsonreuters.com/ConsultaPreciosWS/obtenerPreciosResponse")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(obtenerPreciosResponse))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(obtenerPrecios))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(RequestedRicsResponse))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(RequestedRics))]
        [return: System.ServiceModel.MessageParameterAttribute(Name="return")]
        ConsoleApplication3.WSReuters.obtenerPreciosResponse1 obtenerPrecios(ConsoleApplication3.WSReuters.obtenerPreciosRequest request);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://ws.rfa.thomsonreuters.com/ConsultaPreciosWS/obtenerPreciosRequest", ReplyAction="http://ws.rfa.thomsonreuters.com/ConsultaPreciosWS/obtenerPreciosResponse")]
        System.Threading.Tasks.Task<ConsoleApplication3.WSReuters.obtenerPreciosResponse1> obtenerPreciosAsync(ConsoleApplication3.WSReuters.obtenerPreciosRequest request);
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://ws.rfa.thomsonreuters.com/")]
    public partial class objtWSReutersData : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string txtIRCField;
        
        private object[] txtFLDField;
        
        private object[] txtFLDValField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string txtIRC {
            get {
                return this.txtIRCField;
            }
            set {
                this.txtIRCField = value;
                this.RaisePropertyChanged("txtIRC");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("txtFLD", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, IsNullable=true, Order=1)]
        public object[] txtFLD {
            get {
                return this.txtFLDField;
            }
            set {
                this.txtFLDField = value;
                this.RaisePropertyChanged("txtFLD");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("txtFLDVal", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, IsNullable=true, Order=2)]
        public object[] txtFLDVal {
            get {
                return this.txtFLDValField;
            }
            set {
                this.txtFLDValField = value;
                this.RaisePropertyChanged("txtFLDVal");
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
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://ws.rfa.thomsonreuters.com/")]
    public partial class campo : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string fLDField;
        
        private string vALField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string FLD {
            get {
                return this.fLDField;
            }
            set {
                this.fLDField = value;
                this.RaisePropertyChanged("FLD");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string VAL {
            get {
                return this.vALField;
            }
            set {
                this.vALField = value;
                this.RaisePropertyChanged("VAL");
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
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://ws.rfa.thomsonreuters.com/")]
    public partial class campos : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string rICField;
        
        private campo[] fLDField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string RIC {
            get {
                return this.rICField;
            }
            set {
                this.rICField = value;
                this.RaisePropertyChanged("RIC");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("FLD", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public campo[] FLD {
            get {
                return this.fLDField;
            }
            set {
                this.fLDField = value;
                this.RaisePropertyChanged("FLD");
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
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://ws.rfa.thomsonreuters.com/")]
    public partial class obtenerPreciosResponse : object, System.ComponentModel.INotifyPropertyChanged {
        
        private campos[] returnField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        [System.Xml.Serialization.XmlArrayItemAttribute("PRICE", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, IsNullable=false)]
        public campos[] @return {
            get {
                return this.returnField;
            }
            set {
                this.returnField = value;
                this.RaisePropertyChanged("return");
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
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://ws.rfa.thomsonreuters.com/")]
    public partial class obtenerPrecios : object, System.ComponentModel.INotifyPropertyChanged {
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://ws.rfa.thomsonreuters.com/")]
    public partial class RequestedRicsResponse : object, System.ComponentModel.INotifyPropertyChanged {
        
        private objtWSReutersData returnField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public objtWSReutersData @return {
            get {
                return this.returnField;
            }
            set {
                this.returnField = value;
                this.RaisePropertyChanged("return");
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
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://ws.rfa.thomsonreuters.com/")]
    public partial class RequestedRics : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string jsonStringRequestField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string jsonStringRequest {
            get {
                return this.jsonStringRequestField;
            }
            set {
                this.jsonStringRequestField = value;
                this.RaisePropertyChanged("jsonStringRequest");
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
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="RequestedRics", WrapperNamespace="http://ws.rfa.thomsonreuters.com/", IsWrapped=true)]
    internal partial class RequestedRicsRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://ws.rfa.thomsonreuters.com/", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public string jsonStringRequest;
        
        public RequestedRicsRequest() {
        }
        
        public RequestedRicsRequest(string jsonStringRequest) {
            this.jsonStringRequest = jsonStringRequest;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="RequestedRicsResponse", WrapperNamespace="http://ws.rfa.thomsonreuters.com/", IsWrapped=true)]
    internal partial class RequestedRicsResponse1 {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://ws.rfa.thomsonreuters.com/", Order=0)]
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public ConsoleApplication3.WSReuters.objtWSReutersData @return;
        
        public RequestedRicsResponse1() {
        }
        
        public RequestedRicsResponse1(ConsoleApplication3.WSReuters.objtWSReutersData @return) {
            this.@return = @return;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="obtenerPrecios", WrapperNamespace="http://ws.rfa.thomsonreuters.com/", IsWrapped=true)]
    internal partial class obtenerPreciosRequest {
        
        public obtenerPreciosRequest() {
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="obtenerPreciosResponse", WrapperNamespace="http://ws.rfa.thomsonreuters.com/", IsWrapped=true)]
    internal partial class obtenerPreciosResponse1 {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://ws.rfa.thomsonreuters.com/", Order=0)]
        [System.Xml.Serialization.XmlArrayAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified)]
        [System.Xml.Serialization.XmlArrayItemAttribute("PRICE", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, IsNullable=false)]
        public ConsoleApplication3.WSReuters.campos[] @return;
        
        public obtenerPreciosResponse1() {
        }
        
        public obtenerPreciosResponse1(ConsoleApplication3.WSReuters.campos[] @return) {
            this.@return = @return;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    internal interface ConsultaPreciosWSChannel : ConsoleApplication3.WSReuters.ConsultaPreciosWS, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    internal partial class ConsultaPreciosWSClient : System.ServiceModel.ClientBase<ConsoleApplication3.WSReuters.ConsultaPreciosWS>, ConsoleApplication3.WSReuters.ConsultaPreciosWS {
        
        public ConsultaPreciosWSClient() {
        }
        
        public ConsultaPreciosWSClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public ConsultaPreciosWSClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ConsultaPreciosWSClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ConsultaPreciosWSClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        ConsoleApplication3.WSReuters.RequestedRicsResponse1 ConsoleApplication3.WSReuters.ConsultaPreciosWS.RequestedRics(ConsoleApplication3.WSReuters.RequestedRicsRequest request) {
            return base.Channel.RequestedRics(request);
        }
        
        public ConsoleApplication3.WSReuters.objtWSReutersData RequestedRics(string jsonStringRequest) {
            ConsoleApplication3.WSReuters.RequestedRicsRequest inValue = new ConsoleApplication3.WSReuters.RequestedRicsRequest();
            inValue.jsonStringRequest = jsonStringRequest;
            ConsoleApplication3.WSReuters.RequestedRicsResponse1 retVal = ((ConsoleApplication3.WSReuters.ConsultaPreciosWS)(this)).RequestedRics(inValue);
            return retVal.@return;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.Threading.Tasks.Task<ConsoleApplication3.WSReuters.RequestedRicsResponse1> ConsoleApplication3.WSReuters.ConsultaPreciosWS.RequestedRicsAsync(ConsoleApplication3.WSReuters.RequestedRicsRequest request) {
            return base.Channel.RequestedRicsAsync(request);
        }
        
        public System.Threading.Tasks.Task<ConsoleApplication3.WSReuters.RequestedRicsResponse1> RequestedRicsAsync(string jsonStringRequest) {
            ConsoleApplication3.WSReuters.RequestedRicsRequest inValue = new ConsoleApplication3.WSReuters.RequestedRicsRequest();
            inValue.jsonStringRequest = jsonStringRequest;
            return ((ConsoleApplication3.WSReuters.ConsultaPreciosWS)(this)).RequestedRicsAsync(inValue);
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        ConsoleApplication3.WSReuters.obtenerPreciosResponse1 ConsoleApplication3.WSReuters.ConsultaPreciosWS.obtenerPrecios(ConsoleApplication3.WSReuters.obtenerPreciosRequest request) {
            return base.Channel.obtenerPrecios(request);
        }
        
        public ConsoleApplication3.WSReuters.campos[] obtenerPrecios() {
            ConsoleApplication3.WSReuters.obtenerPreciosRequest inValue = new ConsoleApplication3.WSReuters.obtenerPreciosRequest();
            ConsoleApplication3.WSReuters.obtenerPreciosResponse1 retVal = ((ConsoleApplication3.WSReuters.ConsultaPreciosWS)(this)).obtenerPrecios(inValue);
            return retVal.@return;
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        System.Threading.Tasks.Task<ConsoleApplication3.WSReuters.obtenerPreciosResponse1> ConsoleApplication3.WSReuters.ConsultaPreciosWS.obtenerPreciosAsync(ConsoleApplication3.WSReuters.obtenerPreciosRequest request) {
            return base.Channel.obtenerPreciosAsync(request);
        }
        
        public System.Threading.Tasks.Task<ConsoleApplication3.WSReuters.obtenerPreciosResponse1> obtenerPreciosAsync() {
            ConsoleApplication3.WSReuters.obtenerPreciosRequest inValue = new ConsoleApplication3.WSReuters.obtenerPreciosRequest();
            return ((ConsoleApplication3.WSReuters.ConsultaPreciosWS)(this)).obtenerPreciosAsync(inValue);
        }
    }
}