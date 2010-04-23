<%
/**
 * Copyright (c) 2000-2010 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@ include file="/html/portlet/portlet_configuration/init.jsp" %>

<%
String redirect = ParamUtil.getString(request, "redirect");
String returnToFullPageURL = ParamUtil.getString(request, "returnToFullPageURL");

String portletResource = ParamUtil.getString(request, "portletResource");

List<PublicRenderParameterConfiguration> publicRenderParameterConfigurations = (List<PublicRenderParameterConfiguration>)request.getAttribute(WebKeys.PUBLIC_RENDER_PARAMETER_CONFIGURATIONS);
Set<PublicRenderParameter> publicRenderParameters = (Set<PublicRenderParameter>)request.getAttribute(WebKeys.PUBLIC_RENDER_PARAMETERS);

PortletURL editPublicRenderParameterURL = renderResponse.createRenderURL();

editPublicRenderParameterURL.setParameter("struts_action", "/portlet_configuration/edit_public_render_parameters");
editPublicRenderParameterURL.setParameter("redirect", redirect);
editPublicRenderParameterURL.setParameter("returnToFullPageURL", returnToFullPageURL);
editPublicRenderParameterURL.setParameter("portletResource", portletResource);
%>

<liferay-util:include page="/html/portlet/portlet_configuration/tabs1.jsp">
	<liferay-util:param name="tabs1" value="communication" />
</liferay-util:include>

<liferay-ui:error key="duplicateMapping" message="several-shared-parameters-are-mapped-to-the-same-parameter" />

<portlet:actionURL var="editPRPURL">
	<portlet:param name="struts_action" value="/portlet_configuration/edit_public_render_parameters" />
	<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.SAVE %>" />
</portlet:actionURL>

<aui:form action="<%= editPRPURL %>" method="post" name="fm">
	<aui:input name="redirect" type="hidden" value="<%= editPublicRenderParameterURL.toString() %>" />
	<aui:input name="returnToFullPageURL" type="hidden" value="<%= returnToFullPageURL %>" />
	<aui:input name="portletResource" type="hidden" value="<%= portletResource %>" />

	<liferay-ui:search-container>
		<liferay-ui:search-container-results
			results="<%= ListUtil.subList(publicRenderParameterConfigurations, searchContainer.getStart(), searchContainer.getEnd()) %>"
			total="<%= publicRenderParameterConfigurations.size() %>"
		/>

		<liferay-ui:search-container-row
			className="PublicRenderParameterConfiguration"
			modelVar="publicRenderParameterConfiguration"
		>
			<liferay-ui:search-container-column-text
				name="shared-parameter"
				value="<%= publicRenderParameterConfiguration.getPublicRenderParameter().getIdentifier() %>"
			/>

			<liferay-ui:search-container-column-text
				name="ignore"
			>
				<aui:input label="" name="<%= PublicRenderParameterConfiguration.IGNORE_PREFIX + publicRenderParameterConfiguration.getPublicRenderParameterName() %>" type="checkbox" value="<%= publicRenderParameterConfiguration.isIgnore() %>" />
			</liferay-ui:search-container-column-text>

			<liferay-ui:search-container-column-text
				name="mapping"
			>
				<aui:select label="" name="<%= PublicRenderParameterConfiguration.MAPPING_PREFIX + publicRenderParameterConfiguration.getPublicRenderParameterName() %>">

					<%
					String sharedParameterCurrentMapping = publicRenderParameterConfiguration.getMapping();
					String sharedParameterName = publicRenderParameterConfiguration.getPublicRenderParameterName();
					%>

					<aui:option label="no-mapping" value="" />

					<%
					for (PublicRenderParameter publicRenderParameter : publicRenderParameters) {
						String identifier = PortletQNameUtil.getPublicRenderParameterName(publicRenderParameter.getQName());

						if (identifier.equals(sharedParameterName)) {
							continue;
						}

						String displayedIdentifier = publicRenderParameter.getIdentifier();

					%>

						<aui:option label="<%= displayedIdentifier %>" selected="<%= identifier.equals(sharedParameterCurrentMapping) %>" value="<%= identifier %>" />

					<%
					}
					%>

				</aui:select>
			</liferay-ui:search-container-column-text>
		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator paginate="<%= false %>" />
	</liferay-ui:search-container>

	<aui:button-row>
		<aui:button type="submit" />

		<aui:button onClick="<%= redirect %>" type="cancel" />
	</aui:button-row>
</aui:form>

<aui:script use="aui-base">

	<%
	for (PublicRenderParameterConfiguration publicRenderParameterConfiguration : publicRenderParameterConfigurations) {
	%>

		Liferay.Util.disableToggleBoxes("<portlet:namespace /><%= PublicRenderParameterConfiguration.IGNORE_PREFIX + publicRenderParameterConfiguration.getPublicRenderParameterName() %>" + "Checkbox", "<portlet:namespace /><%= PublicRenderParameterConfiguration.MAPPING_PREFIX + publicRenderParameterConfiguration.getPublicRenderParameterName() %>", true);

	<%
	}
	%>

</aui:script>