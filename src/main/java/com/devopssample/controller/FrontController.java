package com.devopssample.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author rakeshnarang
 *
 */
@Controller
@RequestMapping(value = "/")
public class FrontController{
	
	/**
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "", method = RequestMethod.GET)
	public ModelAndView getHomeView(HttpServletRequest request) {
		return new ModelAndView("home");
	}

}
