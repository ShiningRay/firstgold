# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # set the browser title
  def title page_title
    content_for(:title){ page_title || @page_title}
  end
  # join all the stylesheets
  def blueprint_css
    stylesheet_link_tag( 'screen', :media => 'screen,projection') +
    stylesheet_link_tag( 'print', :media => 'print') +
    '<!--[if IE]>'.html_safe +
    stylesheet_link_tag( 'ie', :media => 'screen,projection') +
    '<![endif]-->'.html_safe
  end
  # show an question icon
  def icon(name)
    content_tag :div,(content_tag :div, '', :class => name), :class => 'ico'
  end
end
