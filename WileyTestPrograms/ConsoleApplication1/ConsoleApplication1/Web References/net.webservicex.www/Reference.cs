﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18444
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by Microsoft.VSDesigner, Version 4.0.30319.18444.
// 
#pragma warning disable 1591

namespace ConsoleApplication1.net.webservicex.www {
    using System;
    using System.Web.Services;
    using System.Diagnostics;
    using System.Web.Services.Protocols;
    using System.Xml.Serialization;
    using System.ComponentModel;
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.18408")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Web.Services.WebServiceBindingAttribute(Name="CurrencyConvertorSoap", Namespace="http://www.webserviceX.NET/")]
    public partial class CurrencyConvertor : System.Web.Services.Protocols.SoapHttpClientProtocol {
        
        private System.Threading.SendOrPostCallback ConversionRateOperationCompleted;
        
        private bool useDefaultCredentialsSetExplicitly;
        
        /// <remarks/>
        public CurrencyConvertor() {
            this.Url = global::ConsoleApplication1.Properties.Settings.Default.ConsoleApplication1_net_webservicex_www_CurrencyConvertor;
            if ((this.IsLocalFileSystemWebService(this.Url) == true)) {
                this.UseDefaultCredentials = true;
                this.useDefaultCredentialsSetExplicitly = false;
            }
            else {
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        public new string Url {
            get {
                return base.Url;
            }
            set {
                if ((((this.IsLocalFileSystemWebService(base.Url) == true) 
                            && (this.useDefaultCredentialsSetExplicitly == false)) 
                            && (this.IsLocalFileSystemWebService(value) == false))) {
                    base.UseDefaultCredentials = false;
                }
                base.Url = value;
            }
        }
        
        public new bool UseDefaultCredentials {
            get {
                return base.UseDefaultCredentials;
            }
            set {
                base.UseDefaultCredentials = value;
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        /// <remarks/>
        public event ConversionRateCompletedEventHandler ConversionRateCompleted;
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://www.webserviceX.NET/ConversionRate", RequestNamespace="http://www.webserviceX.NET/", ResponseNamespace="http://www.webserviceX.NET/", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        public double ConversionRate(Currency FromCurrency, Currency ToCurrency) {
            object[] results = this.Invoke("ConversionRate", new object[] {
                        FromCurrency,
                        ToCurrency});
            return ((double)(results[0]));
        }
        
        /// <remarks/>
        public void ConversionRateAsync(Currency FromCurrency, Currency ToCurrency) {
            this.ConversionRateAsync(FromCurrency, ToCurrency, null);
        }
        
        /// <remarks/>
        public void ConversionRateAsync(Currency FromCurrency, Currency ToCurrency, object userState) {
            if ((this.ConversionRateOperationCompleted == null)) {
                this.ConversionRateOperationCompleted = new System.Threading.SendOrPostCallback(this.OnConversionRateOperationCompleted);
            }
            this.InvokeAsync("ConversionRate", new object[] {
                        FromCurrency,
                        ToCurrency}, this.ConversionRateOperationCompleted, userState);
        }
        
        private void OnConversionRateOperationCompleted(object arg) {
            if ((this.ConversionRateCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.ConversionRateCompleted(this, new ConversionRateCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        public new void CancelAsync(object userState) {
            base.CancelAsync(userState);
        }
        
        private bool IsLocalFileSystemWebService(string url) {
            if (((url == null) 
                        || (url == string.Empty))) {
                return false;
            }
            System.Uri wsUri = new System.Uri(url);
            if (((wsUri.Port >= 1024) 
                        && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) {
                return true;
            }
            return false;
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34234")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://www.webserviceX.NET/")]
    public enum Currency {
        
        /// <remarks/>
        AFA,
        
        /// <remarks/>
        ALL,
        
        /// <remarks/>
        DZD,
        
        /// <remarks/>
        ARS,
        
        /// <remarks/>
        AWG,
        
        /// <remarks/>
        AUD,
        
        /// <remarks/>
        BSD,
        
        /// <remarks/>
        BHD,
        
        /// <remarks/>
        BDT,
        
        /// <remarks/>
        BBD,
        
        /// <remarks/>
        BZD,
        
        /// <remarks/>
        BMD,
        
        /// <remarks/>
        BTN,
        
        /// <remarks/>
        BOB,
        
        /// <remarks/>
        BWP,
        
        /// <remarks/>
        BRL,
        
        /// <remarks/>
        GBP,
        
        /// <remarks/>
        BND,
        
        /// <remarks/>
        BIF,
        
        /// <remarks/>
        XOF,
        
        /// <remarks/>
        XAF,
        
        /// <remarks/>
        KHR,
        
        /// <remarks/>
        CAD,
        
        /// <remarks/>
        CVE,
        
        /// <remarks/>
        KYD,
        
        /// <remarks/>
        CLP,
        
        /// <remarks/>
        CNY,
        
        /// <remarks/>
        COP,
        
        /// <remarks/>
        KMF,
        
        /// <remarks/>
        CRC,
        
        /// <remarks/>
        HRK,
        
        /// <remarks/>
        CUP,
        
        /// <remarks/>
        CYP,
        
        /// <remarks/>
        CZK,
        
        /// <remarks/>
        DKK,
        
        /// <remarks/>
        DJF,
        
        /// <remarks/>
        DOP,
        
        /// <remarks/>
        XCD,
        
        /// <remarks/>
        EGP,
        
        /// <remarks/>
        SVC,
        
        /// <remarks/>
        EEK,
        
        /// <remarks/>
        ETB,
        
        /// <remarks/>
        EUR,
        
        /// <remarks/>
        FKP,
        
        /// <remarks/>
        GMD,
        
        /// <remarks/>
        GHC,
        
        /// <remarks/>
        GIP,
        
        /// <remarks/>
        XAU,
        
        /// <remarks/>
        GTQ,
        
        /// <remarks/>
        GNF,
        
        /// <remarks/>
        GYD,
        
        /// <remarks/>
        HTG,
        
        /// <remarks/>
        HNL,
        
        /// <remarks/>
        HKD,
        
        /// <remarks/>
        HUF,
        
        /// <remarks/>
        ISK,
        
        /// <remarks/>
        INR,
        
        /// <remarks/>
        IDR,
        
        /// <remarks/>
        IQD,
        
        /// <remarks/>
        ILS,
        
        /// <remarks/>
        JMD,
        
        /// <remarks/>
        JPY,
        
        /// <remarks/>
        JOD,
        
        /// <remarks/>
        KZT,
        
        /// <remarks/>
        KES,
        
        /// <remarks/>
        KRW,
        
        /// <remarks/>
        KWD,
        
        /// <remarks/>
        LAK,
        
        /// <remarks/>
        LVL,
        
        /// <remarks/>
        LBP,
        
        /// <remarks/>
        LSL,
        
        /// <remarks/>
        LRD,
        
        /// <remarks/>
        LYD,
        
        /// <remarks/>
        LTL,
        
        /// <remarks/>
        MOP,
        
        /// <remarks/>
        MKD,
        
        /// <remarks/>
        MGF,
        
        /// <remarks/>
        MWK,
        
        /// <remarks/>
        MYR,
        
        /// <remarks/>
        MVR,
        
        /// <remarks/>
        MTL,
        
        /// <remarks/>
        MRO,
        
        /// <remarks/>
        MUR,
        
        /// <remarks/>
        MXN,
        
        /// <remarks/>
        MDL,
        
        /// <remarks/>
        MNT,
        
        /// <remarks/>
        MAD,
        
        /// <remarks/>
        MZM,
        
        /// <remarks/>
        MMK,
        
        /// <remarks/>
        NAD,
        
        /// <remarks/>
        NPR,
        
        /// <remarks/>
        ANG,
        
        /// <remarks/>
        NZD,
        
        /// <remarks/>
        NIO,
        
        /// <remarks/>
        NGN,
        
        /// <remarks/>
        KPW,
        
        /// <remarks/>
        NOK,
        
        /// <remarks/>
        OMR,
        
        /// <remarks/>
        XPF,
        
        /// <remarks/>
        PKR,
        
        /// <remarks/>
        XPD,
        
        /// <remarks/>
        PAB,
        
        /// <remarks/>
        PGK,
        
        /// <remarks/>
        PYG,
        
        /// <remarks/>
        PEN,
        
        /// <remarks/>
        PHP,
        
        /// <remarks/>
        XPT,
        
        /// <remarks/>
        PLN,
        
        /// <remarks/>
        QAR,
        
        /// <remarks/>
        ROL,
        
        /// <remarks/>
        RUB,
        
        /// <remarks/>
        WST,
        
        /// <remarks/>
        STD,
        
        /// <remarks/>
        SAR,
        
        /// <remarks/>
        SCR,
        
        /// <remarks/>
        SLL,
        
        /// <remarks/>
        XAG,
        
        /// <remarks/>
        SGD,
        
        /// <remarks/>
        SKK,
        
        /// <remarks/>
        SIT,
        
        /// <remarks/>
        SBD,
        
        /// <remarks/>
        SOS,
        
        /// <remarks/>
        ZAR,
        
        /// <remarks/>
        LKR,
        
        /// <remarks/>
        SHP,
        
        /// <remarks/>
        SDD,
        
        /// <remarks/>
        SRG,
        
        /// <remarks/>
        SZL,
        
        /// <remarks/>
        SEK,
        
        /// <remarks/>
        CHF,
        
        /// <remarks/>
        SYP,
        
        /// <remarks/>
        TWD,
        
        /// <remarks/>
        TZS,
        
        /// <remarks/>
        THB,
        
        /// <remarks/>
        TOP,
        
        /// <remarks/>
        TTD,
        
        /// <remarks/>
        TND,
        
        /// <remarks/>
        TRL,
        
        /// <remarks/>
        USD,
        
        /// <remarks/>
        AED,
        
        /// <remarks/>
        UGX,
        
        /// <remarks/>
        UAH,
        
        /// <remarks/>
        UYU,
        
        /// <remarks/>
        VUV,
        
        /// <remarks/>
        VEB,
        
        /// <remarks/>
        VND,
        
        /// <remarks/>
        YER,
        
        /// <remarks/>
        YUM,
        
        /// <remarks/>
        ZMK,
        
        /// <remarks/>
        ZWD,
        
        /// <remarks/>
        TRY,
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.18408")]
    public delegate void ConversionRateCompletedEventHandler(object sender, ConversionRateCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.18408")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class ConversionRateCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal ConversionRateCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public double Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((double)(this.results[0]));
            }
        }
    }
}

#pragma warning restore 1591