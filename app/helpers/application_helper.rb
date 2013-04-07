# -*- coding: utf-8 -*-
module ApplicationHelper
  def title
    @title || t("title.#{controller_name}.#{action_name}")
  end

  def logged_in?
    current_user
  end

  def show_correctness(correct)
    if correct
      image_tag('ok.png')
    else
      image_tag('ng.png')
    end
  end    

  def show_percent(percent)
    content_tag(:span, content_tag(:span, "&nbsp;#{percent}%", :style =>"width:#{percent}%; overflow:visible;"), :class=>'percent')
  end

  def true_false(bool)
    if bool
      'Тийм'
    else
      'Үгүй'
    end
  end

  def sec2milisec(sec)
      "%0.3f" % (sec.to_f/1000)
  end

  def translate_message(execution_state)
    state = Usage::State.get(execution_state)

    image_tag("run-#{state.abbr}.png",
              :title => t(state.abbr, :scope =>'label.execution'))
  end

  def test_purpose(viewable)
    if viewable
      image_tag('test-hidden.png', :title => 'Харагдахгүй тэст')
    else
      link_to(image_tag('test-open.png', :title => 'арах'), result)
    end
  end

  def render_viewable(hidden)
    if !hidden
      image_tag('test-open.png', :title => 'Харагдана')
    else
      image_tag('test-hidden.png', :title => 'Харагдахгүй')
    end
  end

  def medal_list(standings)
    list =''
    medal_color = 1
    standings.sort{|a,b| a[1]<=>b[1]}.each { |c, s|
      if s < 4
        if medal_color != s
          medal_color = s
          list += '<br />'
        end
        list += link_to(standing(s),c)
      end
    }
    return list
  end

  def prepare_wmd_if(needed)
    if needed
      js = stylesheet_link_tag('wmd')
      js << javascript_include_tag('showdown')
      js << javascript_tag('wmd_options = {"output":"Markdown"}')
      js << javascript_include_tag('wmd')      
      js << javascript_tag('$(function() { createWmd("textarea", "#preview"); }); ')
    end
  end
end
