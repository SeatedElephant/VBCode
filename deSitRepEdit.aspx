<%@ Page Title="" Language="VB" MasterPageFile="/iristest/scripts/secure.master" AutoEventWireup="false" CodeFile="./deSitRepEdit.vb" Inherits="deSitRepEdit" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="Server">
<head>
</head>
<body>
	<div id="PageTitle">
		<h5><a href="/iristest/iData/">Data Capture</a> /
		<a href="/iristest/iData/SitRep/">SitRep</a> /</h5>
        <h2>SitRep Edit</h2>
        <div id="infoParagraph" runat="server">
            <h3>To edit SitRep data that has already been entered click on <strong>Edit</strong> at the left of the relevant record. SitReps can be filtered by 
            hospital by selecting a hospital from the drop down menu.</h3>
        </div>
    </div>
    <br>
	<div id="editSummary" runat="server" style="display:block;">
		<h5>
			<asp:Textbox ID="editSearch" runat="server" style="display:none;"/>
			<table width = "100%">
				<tr>
					<td width="30%"><strong>Hospital:</strong></td>
					<td>
						<asp:DropDownList id="ddlHosp" runat="server" OnSelectedIndexChanged="getRecords" AutoPostBack="true" CausesValidation="false">
							<asp:ListItem Selected="True" Value="All">All</asp:ListItem>
							<asp:ListItem Value="BGH">Bronglais General Hospital</asp:ListItem>
							<asp:ListItem Value="GGH">Glangwili General Hospital</asp:ListItem>
							<asp:ListItem Value="PPH">Prince Philip Hospital</asp:ListItem>
							<asp:ListItem Value="WGH">Withybush General Hospital</asp:ListItem>
						</asp:DropDownList>
					</td>
				</tr>
			</table>
		</h5>
		<asp:Repeater ID="editRepeater" runat="server"> 
			<HeaderTemplate>
				<h5><hr>
			</HeaderTemplate>
			<ItemTemplate>
					<table width="100%"> 
						<tr>
							<td width="5%"><asp:LinkButton ID="edtRecLB" Text="Edit" onCommand="edtRecBtnClk" CommandArgument=<%#DataBinder.Eval(Container.DataItem,"SR_ID")%> runat="server"/></td>
							<td width="35%" style=" vertical-align:text-top;">Hospital:&nbsp&nbsp<strong><%#DataBinder.Eval(Container.DataItem,"SR_Site")%></strong></td>
							<td width="20%" style=" vertical-align:text-top;">Date:&nbsp&nbsp<strong><%#DataBinder.Eval(Container.DataItem,"SR_Date","{0:dd/MM/yyyy}")%></strong></td>
							<td width="33%" style=" vertical-align:text-top;">Time:&nbsp&nbsp<strong><%#DataBinder.Eval(Container.DataItem,"SR_Time_Text")%></strong></td>
							<td width="7%"></td>
						</tr>     
						<tr>
							<td></td>
							<td>Patient Safety Risk Score:</td>
							<td><%#DataBinder.Eval(Container.DataItem,"CP_Risk")%></td>
							<td>Escalation Level:</td>
							<td><%#DataBinder.Eval(Container.DataItem,"CP_Escalation")%></td>
						</tr> 
						<tr>
							<td></td>
							<td>Balance on Prediction (Surgical):</td>
							<td><%#DataBinder.Eval(Container.DataItem,"Pre_Calc_BP_Surg")%></td>
							<td>Balance on Prediction (Medical):</td>
							<td><%#DataBinder.Eval(Container.DataItem,"Pre_Calc_BP_Med")%></td>
						</tr> 
						<tr>
							<td></td>
							<td>Balance on Actual (Surgical):</td>
							<td><%#DataBinder.Eval(Container.DataItem,"Pre_Calc_BA_Surg")%></td>
							<td>Balance on Actual (Medical):</td>
							<td><%#DataBinder.Eval(Container.DataItem,"Pre_Calc_BA_Med")%></td>
						</tr> 
					</table>
					<hr>
			</ItemTemplate>
			<FooterTemplate>
				</h5>
			</FooterTemplate>
		</asp:Repeater>
		<asp:Textbox ID="pageStart" runat="server" style="display:none;"/>
		<asp:Textbox ID="pageEnd" runat="server" style="display:none;"/>
		<asp:Textbox ID="pageCount" runat="server" style="display:none;"/>
		<h5>Pages :
		<asp:Repeater ID="patPage" runat="server" onitemcommand="patPaging">
			<ItemTemplate>
				<asp:LinkButton ID="lnkPage" style="padding:4px;" CommandName="Page" CommandArgument="<%# Container.DataItem %>" runat="server"><%# Container.DataItem %></asp:LinkButton>
			</ItemTemplate>
		</asp:Repeater></h5>
	</div>
	<div id="hiddenF" style="display:none;" runat="server">
		<asp:Label ID="edtSR_ID" runat="server" Width="100px" />
		<asp:Label ID="edtTime" runat="server" Width="100px" />
	</div>
	<div id="editSitRep" runat="server" style="display:none;">
		<h3><strong>Edit SitRep</strong></h3>
		<h5>
			<table width="100%">
				<tr>
					<td width="47%">Hospital</td>
					<td width="53%"><strong><asp:Label id="edtHosp" runat="server"></asp:Label></strong></td>
				</tr>
				<tr>
					<td>Date</td>
					<td><strong><asp:Label ID="edtDate" runat="server" Width="100px"></asp:Label></strong></td>
				</tr>
				<tr>
					<td style=" vertical-align:text-top;">Time of Day</td>
					<td><strong><asp:Label ID="edtTimeTxt" runat="server" Width="100px"></asp:TextBox></asp:Label></strong></td>
				</tr>    
			</table>

	<!-- Start of the edit record form -->

        <table width="100%">
            <tr>
                <td><h3><strong>Current Position</strong></h3></td>
                <td></td>
                <td></td>
            </tr>
        </table>
        <table width="100%">
            <tr>
                <td width="47%">Patient Safety Risk Score</td>
                <td width="53%">
					<asp:TextBox ID="edtRisk" runat="server" Width="50px" OnTextChanged="applyMatrixRisk" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtRisk" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtRisk" ErrorMessage="*Enter a whole number" />
                </td>
            </tr>
            <tr>
                <td>Escalation Level</td>
                <td>
					<asp:TextBox ID="edtEscalationLevel" runat="server" Width="50px" OnTextChanged="applyMatrixEL" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtEscalationLevel" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtEscalationLevel" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ED: Total Number in Department</td>
                <td>
					<asp:TextBox ID="edtTotalNumberInDepartment" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtTotalNumberInDepartment" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtTotalNumberInDepartment" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ED: Number Waiting a Bed</td>
                <td>
					<asp:TextBox ID="edtNumberWaitingBed" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtNumberWaitingBed" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtNumberWaitingBed" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ED: Number Over 12 Hours</td>
                <td>
					<asp:TextBox ID="edtNumberOver12Hours" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtNumberOver12Hours" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtNumberOver12Hours" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ED: Longest Wait (hrs)</td>
                <td>
					<asp:TextBox ID="edtLongestWait" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtLongestWait" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtLongestWait" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ED: Offload Space - Major</td>
                <td>
					<asp:TextBox ID="edtOffloadSpaceMajor" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOffloadSpaceMajor" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtOffloadSpaceMajor" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ED: Offload Space - Minor</td>
                <td>
					<asp:TextBox ID="edtOffloadSpaceMinor" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOffloadSpaceMinor" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtOffloadSpaceMinor" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Ambulance Outside Now</td>
                <td>
					<asp:TextBox ID="edtAmbulanceOutsideNow" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtAmbulanceOutsideNow" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtAmbulanceOutsideNow" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Ambulance En Route</td>
                <td>
					<asp:TextBox ID="edtAmbulanceEnRoute" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtAmbulanceEnRoute" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtAmbulanceEnRoute" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ITU Capacity to Admit</td>
                <td>
					<asp:TextBox ID="edtITUCapacityToAdmit" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtITUCapacityToAdmit" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtITUCapacityToAdmit" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ITU L1</td>
                <td>
					<asp:TextBox ID="edtITUL1" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtITUL1" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtITUL1" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ITU L2</td>
                <td>
					<asp:TextBox ID="edtITUL2" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtITUL2" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtITUL2" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>ITU L3</td>
                <td>
					<asp:TextBox ID="edtITUL3" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtITUL3" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtITUL3" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>CCU</td>
                <td>
					<asp:TextBox ID="edtCCU" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtCCU" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtCCU" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Stroke</td>
                <td>
					<asp:TextBox ID="edtStroke" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtCCU" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtStroke" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>#NOF</td>
                <td>
					<asp:TextBox ID="edtFractureNOF" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtFractureNOF" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtFractureNOF" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Medically Optimised</td>
                <td>
					<asp:TextBox ID="edtMedicallyOptimised" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtMedicallyOptimised" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtMedicallyOptimised" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Medically Optimised & Ready to Transfer</td>
                <td>
					<asp:TextBox ID="edtMedicallyOptimisedTransfer" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtMedicallyOptimisedTransfer" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtMedicallyOptimisedTransfer" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Outliers</td>
                <td>
					<asp:TextBox ID="edtOutliers" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOutliers" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtOutliers" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Surgical Beds Open</td>
                <td>
					<asp:TextBox ID="edtSurgicalBedsOpen" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtSurgicalBedsOpen" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtSurgicalBedsOpen" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Elective Cancellations</td>
                <td>
					<asp:TextBox ID="edtElectiveCancellations" runat="server" Width="50px"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtElectiveCancellations" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtElectiveCancellations" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
        </table>
        <table>
            <tr>
				<td><h3><strong>Demand & Capacity</strong></h3></td>
                <td></td>
                <td></td>
            </tr>
        </table>
        <table width="100%">
            <tr class="table-header">
                <td width="47%"><strong>Predicted Demand:</strong></td>
                <td width="26.5%"><strong>Surgical:</strong></td>
                <td width="26.5%"><strong>Medical:</strong></td>
            </tr>
            <tr>
                <td>Predictions Admissions (rolling average)</td>
                <td>
					<asp:TextBox ID="edtPredictionsAdmissionsSurgical" runat="server" Width="50px" OnTextChanged="calcPDSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtPredictionsAdmissionsSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtPredictionsAdmissionsSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtPredictionsAdmissionsMedical" runat="server" Width="50px" OnTextChanged="calcPDMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtPredictionsAdmissionsMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"
                    ControlToValidate="edtPredictionsAdmissionsMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Overnighters in A&E</td>
                <td>
					<asp:TextBox ID="edtOvernightersInAESurgical" runat="server" Width="50px" OnTextChanged="calcPDSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOvernightersInAESurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtOvernightersInAESurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtOvernightersInAEMedical" runat="server" Width="50px" OnTextChanged="calcPDMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOvernightersInAEMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtOvernightersInAEMedical" ErrorMessage="*Enter a whole number" />
				</td>
        </table>
        <table width="100%" class="srCalcRow">	
            <tr>
                <td width="47%">Total Predicted Demand for the day</td>
                <td width="26.5%"><asp:Label ID="edtCalcDaySurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td width="26.5%"><asp:Label ID="edtCalcDayMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
        </table>
        <table width="100%">
            <tr>
                <td width="47%">Admissions (since midnight)</td>
                <td width="26.5%">
					<asp:TextBox ID="edtAdmissionsSinceMidnightSurgical" runat="server" Width="50px" OnTextChanged="calcPDSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtAdmissionsSinceMidnightSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtAdmissionsSinceMidnightSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td width="26.5%">
					<asp:TextBox ID="edtAdmissionsSinceMidnightMedical" runat="server" Width="50px" OnTextChanged="calcPDMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtAdmissionsSinceMidnightMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtAdmissionsSinceMidnightMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
        </table>
        <table width="100%" class="srCalcRow">	
            <tr>
                <td width="47%">Emergency Admissions Outstanding</td>
                <td width="26.5%"><asp:Label ID="edtCalcAdmOutSurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td width="26.5%"><asp:Label ID="edtCalcAdmOutMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
        </table>
        <br>
        <table width="100%">
            <tr>
                <td width="47%"><strong>Actual Demand:</strong></td>
                <td width="26.5%"><strong>Surgical:</strong></td>
                <td width="26.5%"><strong>Medical:</strong></td>
            </tr>
            <tr>
                <td>Unplaced in A&E</td>
                <td>
					<asp:TextBox ID="edtUnplacedInAESurgical" runat="server" Width="50px" OnTextChanged="calcADSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtUnplacedInAESurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtUnplacedInAESurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtUnplacedInAEMedical" runat="server" Width="50px" OnTextChanged="calcADMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtUnplacedInAEMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtUnplacedInAEMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Ambicare Patient Needing Bed</td>
                <td>
					<asp:TextBox ID="edtAmbicarePatientNeedingBedSurgical" runat="server" Width="50px" OnTextChanged="calcADSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtAmbicarePatientNeedingBedSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtAmbicarePatientNeedingBedSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtAmbicarePatientNeedingBedMedical" runat="server" Width="50px" OnTextChanged="calcADMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtAmbicarePatientNeedingBedMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtAmbicarePatientNeedingBedMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>GP Expected Outstanding</td>
                <td>
					<asp:TextBox ID="edtGPExpectedOutstandingSurgical" runat="server" Width="50px" OnTextChanged="calcADSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtGPExpectedOutstandingSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtGPExpectedOutstandingSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtGPExpectedOutstandingMedical" runat="server" Width="50px" OnTextChanged="calcADMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtGPExpectedOutstandingMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtGPExpectedOutstandingMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Electives Still to be Allocated a Bed</td>
                <td>
					<asp:TextBox ID="edtElectivesStillToBeAllocatedBedSurgical" runat="server" Width="50px" OnTextChanged="calcADSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtElectivesStillToBeAllocatedBedSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtElectivesStillToBeAllocatedBedSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtElectivesStillToBeAllocatedBedMedical" runat="server" Width="50px" OnTextChanged="calcADMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtElectivesStillToBeAllocatedBedMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtElectivesStillToBeAllocatedBedMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Planned ITU to Ward Transfers</td>
                <td>
					<asp:TextBox ID="edtPlannedITUWardTransfersSurgical" runat="server" Width="50px" OnTextChanged="calcADSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtPlannedITUWardTransfersSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtPlannedITUWardTransfersSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtPlannedITUWardTransfersMedical" runat="server" Width="50px" OnTextChanged="calcADMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtPlannedITUWardTransfersMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtPlannedITUWardTransfersMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Offered Repats</td>
                <td>
					<asp:TextBox ID="edtOfferedRepatsSurgical" runat="server" Width="50px" OnTextChanged="calcADSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOfferedRepatsSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtOfferedRepatsSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtOfferedRepatsMedical" runat="server" Width="50px" OnTextChanged="calcADMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOfferedRepatsMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtOfferedRepatsMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Conversion(from DSU, Chemo Unit, MDU etc.)</td>
                <td>
					<asp:TextBox ID="edtConversionSurgical" runat="server" Width="50px" OnTextChanged="calcADSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtConversionSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtConversionSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtConversionMedical" runat="server" Width="50px" OnTextChanged="calcADMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtConversionMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtConversionMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
        </table>
        <table width="100%" class="srCalcRow">	
            <tr>
                <td width="47%">Total Actual Demand</td>
                <td width="26.5%"><asp:Label ID="edtCalcDemandSurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td width="26.5%"><asp:Label ID="edtCalcDemandMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
        </table>
        <br>
        <table width="100%">	
            <tr>
                <td width="47%"><strong>Capacity:</strong></td>
                <td width="26.5%"><strong>Surgical:</strong></td>
                <td width="26.5%"><strong>Medical:</strong></td>
            </tr>
            <tr>
                <td>Current Empty Beds</td>
                <td>
					<asp:TextBox ID="edtCurrentEmptyBedsSurgical" runat="server" Width="50px" OnTextChanged="calcCaSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtCurrentEmptyBedsSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtCurrentEmptyBedsSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtCurrentEmptyBedsMedical" runat="server" Width="50px" OnTextChanged="calcCaMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtCurrentEmptyBedsMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtCurrentEmptyBedsMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Confirmed Discharges</td>
                <td>
					<asp:TextBox ID="edtConfirmedDischargesSurgical" runat="server" Width="50px" OnTextChanged="calcCaSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtConfirmedDischargesSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtConfirmedDischargesSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtConfirmedDischargesMedical" runat="server" Width="50px" OnTextChanged="calcCaMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtConfirmedDischargesMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtConfirmedDischargesMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
            <tr>
                <td>Query Discharges</td>
                <td>
					<asp:TextBox ID="edtQueryDischargesSurgical" runat="server" Width="50px" OnTextChanged="calcCaSurg" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtQueryDischargesSurgical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtQueryDischargesSurgical" ErrorMessage="*Enter a whole number" />
				</td>
                <td>
					<asp:TextBox ID="edtQueryDischargesMedical" runat="server" Width="50px" OnTextChanged="calcCaMedi" AutoPostBack="true"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtQueryDischargesMedical" errormessage="*Required field" />
                    <asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
                    ControlToValidate="edtQueryDischargesMedical" ErrorMessage="*Enter a whole number" />
				</td>
            </tr>
        </table>
        <table width="100%" class="srCalcRow">	
            <tr>
                <td width="47%">Total Inpatient Availability Best Case</td>
                <td width="26.5%"><asp:Label ID="edtCalcAvailabilitySurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td width="26.5%"><asp:Label ID="edtCalcAvailabilityMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
        </table>
		<BR>
        <table width="100%">	
            <tr>
                <td width="47%"><strong>Predictions:</strong></td>
                <td width="26.5%"><strong>Surgical:</strong></td>
                <td width="26.5%"><strong>Medical:</strong></td>
            </tr>
        </table>
        <table width="100%" class="srCalcRow">	
            <tr>
                <td width="47%"><strong>Balance On Prediction</strong><BR>(after housing Ambicare and outstanding electives)</td>
                <td width="26.5%"><asp:Label ID="edtPreCalcBPSurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td width="26.5%"><asp:Label ID="edtPreCalcBPMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
            <tr>
                <td align="right"><font size="1">but if the queries do not happen it will be: &nbsp&nbsp&nbsp</font></td>
                <td><asp:Label ID="edtPreCalcBPDNHSurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td><asp:Label ID="edtPreCalcBPDNHMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
            <tr>
                <td><strong>Balance On Actual</strong><BR>(not relevant until 4pm)</td>
                <td><asp:Label ID="edtPreCalcBASurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td><asp:Label ID="edtPreCalcBAMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
            <tr>
                <td align="right"><font size="1">but if the queries do not happen it will be: &nbsp&nbsp&nbsp</font></td>
                <td><asp:Label ID="edtPreCalcBADNHSurgical" runat="server" Width="50px" enabled="false"></asp:Label></td>
                <td><asp:Label ID="edtPreCalcBADNHMedical" runat="server" Width="50px" enabled="false"></asp:Label></td>
            </tr>
        </table>
        <table>
            <tr>
				<td><h3><strong>Repats & Other Information</strong></h3></td>
                <td></td>
                <td></td>
            </tr>
        </table>
		<table width="100%">
			<tr>
				<td width="23.5%" valign="top">
					<asp:Label><strong>Repats to Come In</strong></asp:Label>
					<asp:Repeater ID="rePatsIn" runat="server">
						<HeaderTemplate>
							<table>
						</HeaderTemplate>
						<ItemTemplate>
								<tr>
									<td width="5%">
										<asp:LinkButton ID="RPDel" runat="server" Text="X" OnClick="DelRPin" title="Remove from Repats" CommandArgument=<%#DataBinder.Eval(Container.DataItem,"RP_ID")%>/>
									</td>
									<td wdith="95%">
										<asp:Label ID="Name" runat="server" Text='<%# Eval("RP_Text").ToString() %>'></asp:Label>
										<asp:Label ID="Type" runat="server" Text='<%# Eval("RP_Type").ToString() %>' style="display:none;"></asp:Label>
									</td>
								</tr>
						</ItemTemplate>
						<FooterTemplate>
							</table>
						</FooterTemplate>
					</asp:Repeater>
				</td>
				<td width="23.5%" valign="top">
					<asp:Label><strong>Repats to Go Out</strong></asp:Label>
					<asp:Repeater ID="rePatsOut" runat="server">
						<HeaderTemplate>
							<table>
						</HeaderTemplate>
						<ItemTemplate>
								<tr>
									<td width="5%">
										<asp:LinkButton ID="RPDel" runat="server" Text="X" OnClick="DelRPout" title="Remove from Repats" CommandArgument=<%#DataBinder.Eval(Container.DataItem,"RP_ID")%>/>
									</td>
									<td wdith="95%">
										<asp:Label ID="Name" runat="server" Text='<%# Eval("RP_Text").ToString() %>'></asp:Label>
										<asp:Label ID="Type" runat="server" Text='<%# Eval("RP_Type").ToString() %>' style="display:none;"></asp:Label>
									</td>
								</tr>
						</ItemTemplate>
						<FooterTemplate>
							</table>
						</FooterTemplate>
					</asp:Repeater>
				</td>
				<td width="53%" valign="top">
					<table width="100%">
						<tr>
							<td width="30%"><strong>Repats:</strong></td>
							<td width="70%">&nbsp;</td>
						</tr>
						<tr>
							<td>Repats Type</td>
							<td>
								<asp:RadioButtonList  id="rbllRepatsType" runat="server" RepeatDirection="Horizontal"> 
									<asp:listitem value="IN" text="Come In" Selected="True"/>
									<asp:listitem value="OUT" text="Go Out" />
								</asp:RadioButtonList>
							</td>
						</tr>
						<tr>
							<td>Repats Value</td>
							<td><asp:TextBox ID="txtRepatsValue" runat="server" Width="150px"></asp:TextBox></td>
						</tr>
						<tr>
							<td></td>
							<td><asp:Button runat="server" Text="Add to Repats" OnClick="addRepats"/></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="100%">
            <tr>
                <td width="47%"><strong>Other Information:</strong></td>
                <td width="53%"></td>
            </tr>
            <tr>
                <td>Staffing Issues</td>
                <td>
					<asp:TextBox ID="edtStaffingIssues" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtStaffingIssues" errormessage="*Required field" />
				</td>
            </tr>
            <tr>
                <td>Infection Control Issues</td>
                <td>
					<asp:TextBox ID="edtInfectionControlIssues" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtInfectionControlIssues" errormessage="*Required field" />
				</td>
            </tr>
            <tr>
                <td>Any Other Issues, incl. Diverts, CT Scanner, etc.</td>
                <td>
					<asp:TextBox ID="edtAnyOtherIssues" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtAnyOtherIssues" errormessage="*Required field" />
				</td>
            </tr>
            <tr>
                <td>Surge Beds Location</td>
                <td>
					<asp:TextBox ID="edtSurgeBedsLocation" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtSurgeBedsLocation" errormessage="*Required field" />
				</td>
            </tr>
            <tr>
                <td>Outlier Beds Location</td>
                <td>
					<asp:TextBox ID="edtOutlierBedsLocation" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    <asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="edtOutlierBedsLocation" errormessage="*Required field" />
				</td>
            </tr>
            <tr>
                <td>&nbsp</td>
                <td>&nbsp</td>
            </tr>
            <tr>
                <td></td>
                <td>
					<asp:Button ID="edtSubmit" runat="server" Text="Submit" Width="100px" onclick="edtRecBTN" ValidationGroup="grp1" />
                    <asp:Button ID="edtCancel" runat="server" Text="Cancel" Width="100px" onclick="cancelBTN"/>
				</td>
            </tr>
        </table>
        </h5>
    </div>
<!---  end form-->
</body>
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ToolkitScriptManager>
</asp:Content>
