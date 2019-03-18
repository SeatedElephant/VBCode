<%@ Page Title="" Language="VB" MasterPageFile="/iristest/scripts/secure.master" AutoEventWireup="false" CodeFile="./deSitRepInput.vb" Inherits="SitRepInput"%>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="Server">
<head>
</head>
<body>
	<div id="hiddenTxt" style="display:none;" runat="server">
		<asp:Textbox ID="valFocus" runat="server"></asp:Textbox>
	</div>
	<div id="PageTitle">
		<h5><a href="/iristest/iData/">Data Capture</a> /
			<a href="/iristest/iData/SitRep/">SitRep</a> /</h5>
			<h2>SitRep Input</h2>
		<div id="infoParagraph" runat="server">
		<h3>To add new data for one of the daily SitReps, select the Hospital, Date and Time of the SitRep from the menus below and then enter the figures.<br>
			Once all the fields have been entered click the <strong>Submit</strong> button. You will then be able to view the data you have entered and either press the <strong>Confirm</strong> button to finish the process 
			or the <strong>Cancel</strong> button to go back and amend your data entries.</h3>
		</div>
		<h4><asp:label CssClass="txtRed" ID="lblUserMessage" runat="server"></asp:label></h4>
	</div>
	<div id="sitMain" runat="server">
		<h5>
			<table width="100%">
				<tr>
					<td width="47%">Hospital</td>
					<td  width="53%">
						<asp:dropdownlist id="ddlHospitalInitials" runat="server"> 
						<asp:listitem value="BGH" text="Bronglais General Hospital"></asp:listitem>
						<asp:listitem value="GGH" text="Glangwili General Hospital"></asp:listitem>
						<asp:listitem value="PPH" text="Prince Philip Hospital"></asp:listitem>
						<asp:listitem value="WGH" text="Withybush General Hospital"></asp:listitem>
						</asp:dropdownlist>
					</td>
				</tr>
				<tr>
					<td>Date</td>
					<td>
						<asp:TextBox ID="txtTheDate" runat="server" Width="100px"></asp:TextBox>
						<asp:CalendarExtender ID="theDateCal" runat="server" Enabled="True" TargetControlID="txtTheDate" 
						PopupButtonID="theDateCalImg" Format="dd/MM/yyyy" EnableViewState="true"></asp:CalendarExtender>
						<asp:ImageButton ID="theDateCalImg" runat="server" ImageUrl="/iristest/commonfiles/images/Icons/calendar.png" />
					</td>
				</tr>
				<tr>
					<td>Time</td>
					<td>
						<asp:dropdownlist id="ddlTheTime" runat="server"> 
						<asp:listitem value="1" text="Morning (08:30)"></asp:listitem>
						<asp:listitem value="2" text="Midday (12:30)"></asp:listitem>
						<asp:listitem value="3" text="Afternoon (15:30"></asp:listitem>
						<asp:listitem value="4" text="Evening (19:30)"></asp:listitem>
						</asp:dropdownlist>
					</td>
				</tr>
			</table>
			<h3><strong>Current Position</strong></h3>
			<table width="100%">
				<tr>
					<td width="47%">Patient Safety Risk Score</td>
					<td width="53%"><asp:TextBox ID="txtRisk" runat="server" Width="50px" OnTextChanged="applyMatrixRisk" AutoPostBack="true"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtRisk" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtRisk" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/>
					</td>
				</tr>
				<tr>
					<td width="47%">Escalation Level</td>
					<td width="53%"><asp:TextBox ID="txtEscalationLevel" runat="server" Width="50px" OnTextChanged="applyMatrixEL" AutoPostBack="true"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic" runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtEscalationLevel" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic" ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtEscalationLevel" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/>
					</td>
				</tr>
				<tr>
					<td>ED: Total Number in Department</td>
					<td><asp:TextBox ID="txtTotalNumberInDepartment" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtTotalNumberInDepartment" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtTotalNumberInDepartment" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ED: Number Waiting a Bed</td>
					<td><asp:TextBox ID="txtNumberWaitingBed" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtNumberWaitingBed" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtNumberWaitingBed" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ED: Number Over 12 Hours</td>
					<td><asp:TextBox ID="txtNumberOver12Hours" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtNumberOver12Hours" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtNumberOver12Hours" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ED: Longest Wait (hrs)</td>
					<td><asp:TextBox ID="txtLongestWait" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtLongestWait" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtLongestWait" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ED: Offload Space - Major</td>
					<td><asp:TextBox ID="txtOffloadSpaceMajor" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOffloadSpaceMajor" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtOffloadSpaceMajor" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ED: Offload Space - Minor</td>
					<td><asp:TextBox ID="txtOffloadSpaceMinor" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOffloadSpaceMinor" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtOffloadSpaceMinor" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Ambulance Outside Now</td>
					<td><asp:TextBox ID="txtAmbulanceOutsideNow" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtAmbulanceOutsideNow" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtAmbulanceOutsideNow" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Ambulance En Route</td>
					<td><asp:TextBox ID="txtAmbulanceEnRoute" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtAmbulanceEnRoute" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtAmbulanceEnRoute" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ITU Capacity to Admit</td>
					<td><asp:TextBox ID="txtITUCapacityToAdmit" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtITUCapacityToAdmit" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtITUCapacityToAdmit" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ITU L1</td>
					<td><asp:TextBox ID="txtITUL1" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtITUL1" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtITUL1" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ITU L2</td>
					<td><asp:TextBox ID="txtITUL2" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtITUL2" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtITUL2" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>ITU L3</td>
					<td><asp:TextBox ID="txtITUL3" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtITUL3" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtITUL3" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>CCU</td>
					<td><asp:TextBox ID="txtCCU" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtCCU" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtCCU" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Stroke</td>
					<td><asp:TextBox ID="txtStroke" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtCCU" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtStroke" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>#NOF</td>
					<td><asp:TextBox ID="txtFractureNOF" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtFractureNOF" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtFractureNOF" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Medically Optimised</td>
					<td><asp:TextBox ID="txtMedicallyOptimised" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtMedicallyOptimised" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtMedicallyOptimised" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Medically Optimised & Ready to Transfer</td>
					<td><asp:TextBox ID="txtMedicallyOptimisedTransfer" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtMedicallyOptimisedTransfer" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtMedicallyOptimisedTransfer" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Outliers</td>
					<td><asp:TextBox ID="txtOutliers" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOutliers" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtOutliers" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Surgical Beds Open</td>
					<td><asp:TextBox ID="txtSurgicalBedsOpen" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtSurgicalBedsOpen" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtSurgicalBedsOpen" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Elective Cancellations</td>
					<td><asp:TextBox ID="txtElectiveCancellations" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtElectiveCancellations" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtElectiveCancellations" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
			</table>
			<h3><strong>Demand & Capacity</strong></h3>
			<table width="100%">
				<tr>
					<td width="47%" ><strong>Predicted Demand:</strong></td>
					<td width="26.5%" ><strong>Surgical:</strong></td>
					<td width="26.5%" ><strong>Medical:</strong></td>
				</tr>
				<tr>
					<td>Predictions Admissions (rolling average)</td>
					<td><asp:TextBox ID="txtPredictionsAdmissionsSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtPredictionsAdmissionsSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtPredictionsAdmissionsSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtPredictionsAdmissionsMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtPredictionsAdmissionsMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"
						ControlToValidate="txtPredictionsAdmissionsMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Overnighters in A&E</td>
					<td><asp:TextBox ID="txtOvernightersInAESurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOvernightersInAESurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtOvernightersInAESurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtOvernightersInAEMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOvernightersInAEMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtOvernightersInAEMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
				<tr>
					<td>Admissions (since midnight)</td>
					<td><asp:TextBox ID="txtAdmissionsSinceMidnightSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtAdmissionsSinceMidnightSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtAdmissionsSinceMidnightSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtAdmissionsSinceMidnightMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtAdmissionsSinceMidnightMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtAdmissionsSinceMidnightMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td>&nbsp</td>
				</tr>
				<tr>
					<td><strong>Actual Demand:</strong></td>
					<td><strong>Surgical:</strong></td>
					<td><strong>Medical:</strong></td>
				</tr>
				<tr>
					<td>Unplaced in A&E</td>
					<td><asp:TextBox ID="txtUnplacedInAESurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtUnplacedInAESurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtUnplacedInAESurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtUnplacedInAEMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtUnplacedInAEMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtUnplacedInAEMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Ambicare Patient Needing Bed</td>
					<td><asp:TextBox ID="txtAmbicarePatientNeedingBedSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtAmbicarePatientNeedingBedSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtAmbicarePatientNeedingBedSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtAmbicarePatientNeedingBedMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtAmbicarePatientNeedingBedMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtAmbicarePatientNeedingBedMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>GP Expected Outstanding</td>
					<td><asp:TextBox ID="txtGPExpectedOutstandingSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtGPExpectedOutstandingSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtGPExpectedOutstandingSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtGPExpectedOutstandingMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtGPExpectedOutstandingMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtGPExpectedOutstandingMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Electives Still to be Allocated a Bed</td>
					<td><asp:TextBox ID="txtElectivesStillToBeAllocatedBedSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtElectivesStillToBeAllocatedBedSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtElectivesStillToBeAllocatedBedSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtElectivesStillToBeAllocatedBedMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtElectivesStillToBeAllocatedBedMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtElectivesStillToBeAllocatedBedMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Planned ITU to Ward Transfers</td>
					<td><asp:TextBox ID="txtPlannedITUWardTransfersSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtPlannedITUWardTransfersSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtPlannedITUWardTransfersSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtPlannedITUWardTransfersMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtPlannedITUWardTransfersMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtPlannedITUWardTransfersMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Offered Repats</td>
					<td><asp:TextBox ID="txtOfferedRepatsSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOfferedRepatsSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtOfferedRepatsSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtOfferedRepatsMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOfferedRepatsMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtOfferedRepatsMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Conversion(from DSU, Chemo Unit, MDU etc.)</td>
					<td><asp:TextBox ID="txtConversionSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtConversionSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtConversionSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtConversionMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtConversionMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtConversionMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td>&nbsp</td>
				</tr>
				<tr>
					<td><strong>Capacity:</strong></td>
					<td><strong>Surgical:</strong></td>
					<td><strong>Medical:</strong></td>
				</tr>
				<tr>
					<td>Current Empty Beds</td>
					<td><asp:TextBox ID="txtCurrentEmptyBedsSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtCurrentEmptyBedsSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtCurrentEmptyBedsSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtCurrentEmptyBedsMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtCurrentEmptyBedsMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtCurrentEmptyBedsMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Confirmed Discharges</td>
					<td><asp:TextBox ID="txtConfirmedDischargesSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtConfirmedDischargesSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtConfirmedDischargesSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtConfirmedDischargesMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtConfirmedDischargesMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtConfirmedDischargesMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
				<tr>
					<td>Query Discharges</td>
					<td><asp:TextBox ID="txtQueryDischargesSurgical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtQueryDischargesSurgical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtQueryDischargesSurgical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
					<td><asp:TextBox ID="txtQueryDischargesMedical" runat="server" Width="50px"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtQueryDischargesMedical" errormessage="*Required field" SetFocusOnError="true"/>
						<asp:CompareValidator Display="Dynamic"   ValidationGroup="grp1" runat="server" Operator="DataTypeCheck" Type="Integer" CssClass="valtxt"  
						ControlToValidate="txtQueryDischargesMedical" ErrorMessage="*Enter a whole number" SetFocusOnError="true"/></td>
				</tr>
			</table>
			<h3><strong>Repats & Other Information</strong></h3>
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
											<asp:LinkButton ID="RPDel" runat="server" Text="X" OnClick="DelRPin" title="Remove from Repats" CommandArgument=<%#DataBinder.Eval(Container.DataItem,"ID")%>/>
										</td>
										<td wdith="95%">
											<asp:Label ID="Name" runat="server" Text='<%# Eval("RP_Value").ToString() %>'></asp:Label>
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
											<asp:LinkButton ID="RPDel" runat="server" Text="X" OnClick="DelRPout" title="Remove from Repats" CommandArgument=<%#DataBinder.Eval(Container.DataItem,"ID")%>/>
										</td>
										<td wdith="95%">
											<asp:Label ID="Name" runat="server" Text='<%# Eval("RP_Value").ToString() %>'></asp:Label>
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
			<BR>
			<table width="100%">
				<tr>
					<td width="47%"><strong>Other Information:</strong></td>
					<td width="53%">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">Staffing Issues</td>
					<td>
						<asp:TextBox ID="txtStaffingIssues" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtStaffingIssues" errormessage="*Required field" SetFocusOnError="true"/>
					</td>
				</tr>
				<tr>
					<td valign="top">Infection Control Issues</td>
					<td>
						<asp:TextBox ID="txtInfectionControlIssues" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtInfectionControlIssues" errormessage="*Required field" SetFocusOnError="true"/>
					</td>
				</tr>
				<tr>
					<td valign="top">Any Other Issues, incl. Diverts, CT Scanner, etc.</td>
					<td>
						<asp:TextBox ID="txtAnyOtherIssues" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtAnyOtherIssues" errormessage="*Required field" SetFocusOnError="true"/>
					</td>
				</tr>
				<tr>
					<td valign="top">Surge Beds Location</td>
					<td>
						<asp:TextBox ID="txtSurgeBedsLocation" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtSurgeBedsLocation" errormessage="*Required field" SetFocusOnError="true"/>
					</td>
				</tr>
				<tr>
					<td valign="top">Outlier Beds Location</td>
					<td>
						<asp:TextBox ID="txtOutlierBedsLocation" runat="server" Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
						<asp:RequiredFieldValidator Display="Dynamic"   runat="server" validationgroup="grp1" CssClass="valtxt" controltovalidate="txtOutlierBedsLocation" errormessage="*Required field" SetFocusOnError="true"/>
					</td>
				</tr>
				<tr>
					<td>&nbsp</td>
					<td>&nbsp</td>
				</tr>
				<tr>
					<td></td>
					<td><asp:Button width="150px" class="centred-text" runat="server" Text="Submit" OnClick="checkIfDuplicate"  /></td>
				</tr>
			</table>			
			<br>
		</h5>
	</div>		

	<!-- below this is the confirmation div this is hidden until the submit button is clicked -->
	<div id="sitConfirm" runat="server" style="display:none;">
		<h5>
			<table width="100%">
				<tr>
					<td width="47%">Hospital</td>
					<td width="53%"><strong><asp:Label id="lblHospitalInitials" runat="server"></asp:Label></strong></td>
				</tr>
				<tr>
					<td>Date</td>
					<td><strong><asp:Label ID="lblTheDate" runat="server" Width="100px"></asp:Label></strong></td>
				</tr>
				<tr>
					<td>Time</td>
					<td><strong><asp:Label id="lblTheTime" runat="server"></asp:Label></strong></td>
				</tr>
			</table>
			<h3><strong>Current Position</strong></h3>
			<table width="100%">
				<tr>
					<td width="47%">Patient Safety Risk Score</td>
					<td width="53%"><asp:Label ID="lblRisk" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td width="47%">Escalation Level</td>
					<td width="53%"><asp:Label ID="lblEscalationLevel" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ED: Total Number in Department</td>
					<td><asp:Label ID="lblTotalNumberInDepartment" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ED: Number Waiting a Bed</td>
					<td><asp:Label ID="lblNumberWaitingBed" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ED: Number Over 12 Hours</td>
					<td><asp:Label ID="lblNumberOver12Hours" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ED: Longest Wait (hrs)</td>
					<td><asp:Label ID="lblLongestWait" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ED: Offload Space - Major</td>
					<td><asp:Label ID="lblOffloadSpaceMajor" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ED: Offload Space - Minor</td>
					<td><asp:Label ID="lblOffloadSpaceMinor" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Ambulance Outside Now</td>
					<td><asp:Label ID="lblAmbulanceOutsideNow" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Ambulance En Route</td>
					<td><asp:Label ID="lblAmbulanceEnRoute" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ITU Capacity to Admit</td>
					<td><asp:Label ID="lblITUCapacityToAdmit" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ITU L1</td>
					<td><asp:Label ID="lblITUL1" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ITU L2</td>
					<td><asp:Label ID="lblITUL2" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>ITU L3</td>
					<td><asp:Label ID="lblITUL3" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>CCU</td>
					<td><asp:Label ID="lblCCU" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Stroke</td>
					<td><asp:Label ID="lblStroke" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>#NOF</td>
					<td><asp:Label ID="lblFractureNOF" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Medically Optimised</td>
					<td><asp:Label ID="lblMedicallyOptimised" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Medically Optimised & Ready to Transfer</td>
					<td><asp:Label ID="lblMedicallyOptimisedTransfer" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Outliers</td>
					<td><asp:Label ID="lblOutliers" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Surgical Beds Open</td>
					<td><asp:Label ID="lblSurgicalBedsOpen" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Elective Cancellations</td>
					<td><asp:Label ID="lblElectiveCancellations" runat="server" Width="50px"></asp:Label></td>
				</tr>
			</table>
			<h3><strong>Demand & Capacity</strong></h3>
			<table width="100%">
				<tr>
					<td width="47%" ><strong>Predicted Demand:</strong></td>
					<td width="26.5%" ><strong>Surgical:</strong></td>
					<td width="26.5%" ><strong>Medical:</strong></td>
				</tr>
				<tr>
					<td>Predictions Admissions (rolling average)</td>
					<td><asp:Label ID="lblPredictionsAdmissionsSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblPredictionsAdmissionsMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Overnighters in A&E</td>
					<td><asp:Label ID="lblOvernightersInAESurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblOvernightersInAEMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr class="srCalcRow">
					<td>Total Predicted Demand for the day</td>
					<td><asp:Label ID="lblCalcDaySurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblCalcDayMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
				<tr>
					<td>Admissions (since midnight)</td>
					<td><asp:Label ID="lblAdmissionsSinceMidnightSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblAdmissionsSinceMidnightMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr class="srCalcRow">
					<td>Emergency Admissions Outstanding</td>
					<td><asp:Label ID="lblCalcAdmOutSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblCalcAdmOutMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td>&nbsp</td>
				</tr>
				<tr>
					<td><strong>Actual Demand:</strong></td>
					<td><strong>Surgical:</strong></td>
					<td><strong>Medical:</strong></td>
				</tr>
				<tr>
					<td>Unplaced in A&E</td>
					<td><asp:Label ID="lblUnplacedInAESurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblUnplacedInAEMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Ambicare Patient Needing Bed</td>
					<td><asp:Label ID="lblAmbicarePatientNeedingBedSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblAmbicarePatientNeedingBedMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>GP Expected Outstanding</td>
					<td><asp:Label ID="lblGPExpectedOutstandingSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblGPExpectedOutstandingMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Electives Still to be Allocated a Bed</td>
					<td><asp:Label ID="lblElectivesStillToBeAllocatedBedSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblElectivesStillToBeAllocatedBedMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Planned ITU to Ward Transfers</td>
					<td><asp:Label ID="lblPlannedITUWardTransfersSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblPlannedITUWardTransfersMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Offered Repats</td>
					<td><asp:Label ID="lblOfferedRepatsSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblOfferedRepatsMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Conversion(from DSU, Chemo Unit, MDU etc.)</td>
					<td><asp:Label ID="lblConversionSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblConversionMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr class="srCalcRow">
					<td>Total Actual Demand</td>
					<td><asp:Label ID="lblCalcDemandSurgical"  runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblCalcDemandMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td>&nbsp</td>
				</tr>
				<tr>	
				<tr class="table-header">
					<td><strong>Capacity:</strong></td>
					<td><strong>Surgical:</strong></td>
					<td><strong>Medical:</strong></td>
				</tr>
				<tr>
					<td>Current Empty Beds</td>
					<td><asp:Label ID="lblCurrentEmptyBedsSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblCurrentEmptyBedsMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Confirmed Discharges</td>
					<td><asp:Label ID="lblConfirmedDischargesSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblConfirmedDischargesMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>Query Discharges</td>
					<td><asp:Label ID="lblQueryDischargesSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblQueryDischargesMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr class="srCalcRow">
					<td>Total Inpatient Availability Best Case</td>
					<td><asp:Label ID="lblCalcAvailabilitySurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblCalcAvailabilityMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr>
					<td>&nbsp</td>
					<td>&nbsp</td>
					<td>&nbsp</td>
				</tr>	
				<tr>
					<td><strong>Predictions:</strong></td>
					<td><strong>Surgical:</strong></td>
					<td><strong>Medical:</strong></td>
				</tr>
				<tr class="srCalcRow">
					<td>Balance On Prediction (after housing Ambicare and outstanding electives)</td>
					<td><asp:Label ID="lblPreCalcBPSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblPreCalcBPMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr class="srCalcRow">
					<td>but if the queries do not happen it will be:</td>
					<td><asp:Label ID="lblPreCalcBPDNHSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblPreCalcBPDNHMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr class="srCalcRow">
					<td>Balance On Actual (not relevant until 4pm)</td>
					<td><asp:Label ID="lblPreCalcBASurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblPreCalcBAMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
				<tr class="srCalcRow">
					<td>but if the queries do not happen it will be:</td>
					<td><asp:Label ID="lblPreCalcBADNHSurgical" runat="server" Width="50px"></asp:Label></td>
					<td><asp:Label ID="lblPreCalcBADNHMedical" runat="server" Width="50px"></asp:Label></td>
				</tr>
			</table>
			<br>
			<strong>Note:</strong> Predictions are only an indicator of potential flow at any point in time and do not seek to provide the exact position at midnight		
			<br>
			<h3><strong>Repats & Other Information:</strong></h3>
			<table width="100%">
				<tr>
					<td width="50%" valign="top">
						<asp:Label><strong>Repats to Come In</strong></asp:Label>
						<asp:Repeater ID="subRePatsIn" runat="server">
							<HeaderTemplate>
								<table>
							</HeaderTemplate>
							<ItemTemplate>
									<tr>
										<td wdith="100%">
											<asp:Label ID="Name" runat="server" Text='<%# Eval("RP_Value").ToString() %>'></asp:Label>
											<asp:Label ID="Type" runat="server" Text='<%# Eval("RP_Type").ToString() %>' style="display:none;"></asp:Label>
										</td>
									</tr>
							</ItemTemplate>
							<FooterTemplate>
								</table>
							</FooterTemplate>
						</asp:Repeater>
					</td>
					<td width="50%" valign="top">
						<asp:Label><strong>Repats to Go Out</strong></asp:Label>
						<asp:Repeater ID="subRePatsOut" runat="server">
							<HeaderTemplate>
								<table>
							</HeaderTemplate>
							<ItemTemplate>
									<tr>
										<td wdith="100%">
											<asp:Label ID="Name" runat="server" Text='<%# Eval("RP_Value").ToString() %>'></asp:Label>
											<asp:Label ID="Type" runat="server" Text='<%# Eval("RP_Type").ToString() %>' style="display:none;"></asp:Label>
										</td>
									</tr>
							</ItemTemplate>
							<FooterTemplate>
								</table>
							</FooterTemplate>
						</asp:Repeater>
					</td>
				</tr>
			</table>
			<BR>
			<table width="100%">
				<tr class="table-header-plain">
					<td ><strong>Other Information:</strong></td>
					<td></td>
				</tr>
				<tr>
					<td>Staffing Issues</td>
					<td><asp:Label ID="lblStaffingIssues" runat="server" Width="300px"></asp:Label></td>
				</tr>
				<tr>
					<td>Infection Control Issues</td>
					<td><asp:Label ID="lblInfectionControlIssues" runat="server" Width="300px"></asp:Label></td>
				</tr>
				<tr>
					<td>Any Other Issues, incl. Diverts, CT Scanner, etc.</td>
					<td><asp:Label ID="lblAnyOtherIssues" runat="server" Width="300px"></asp:Label></td>
				</tr>
				<tr>
					<td>Surge Beds Location</td>
					<td><asp:Label ID="lblSurgeBedsLocation" runat="server" Width="300px"></asp:Label></td>
				</tr>
				<tr>
					<td>Outlier Beds Location</td>
					<td><asp:Label ID="lblOutlierBedsLocation" runat="server" Width="300px"></asp:Label></td>
				</tr>
				<tr>
					<td>&nbsp</td>
					<td>&nbsp</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<asp:Button id="confirmBTN" width="100px" class="centred-text" runat="server" Text="Confirm" OnClick="confirmSubmit" />
						<asp:Button id="cancelBTN" runat="server" class="centred-text" Text="Cancel" Width="100px" onclick="confirmSubmitCancel"/>
					</td>
				</tr>
			</table>
		</h5>
	</div>	
</body>
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ToolkitScriptManager>
</asp:Content>
