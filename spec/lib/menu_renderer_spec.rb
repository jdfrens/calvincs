require 'spec_helper'

describe MenuRenderer do
  before(:each) do
    @template = mock("template")
  end
  
  describe "main render method" do
    it "should generate a list of items from instance variable" do
      menu_items = [mock("item 0"), mock("item 1"), mock("item 2")]
      renderer = MenuRenderer.new(@template, *menu_items)
      
      renderer.should_receive(:render_item).with(menu_items[0]).and_return("li item 0")
      renderer.should_receive(:render_item).with(menu_items[1]).and_return("li item 1")
      renderer.should_receive(:render_item).with(menu_items[2]).and_return("li item 2")
      @template.should_receive(:content_tag).with(:ul, "li item 0 li item 1 li item 2").
        and_return("rendered menu!")

      renderer.render_menu.should == "rendered menu!"
    end

    it "should generate a list of items from parameter" do
      top_level_menu_items = [mock("these items are not rendered")]
      menu_items = [mock("item 0"), mock("item 1"), mock("item 2")]
      renderer = MenuRenderer.new(@template, *top_level_menu_items)
      
      renderer.should_receive(:render_item).with(menu_items[0]).and_return("li item 0")
      renderer.should_receive(:render_item).with(menu_items[1]).and_return("li item 1")
      renderer.should_receive(:render_item).with(menu_items[2]).and_return("li item 2")
      @template.should_receive(:content_tag).with(:ul, "li item 0 li item 1 li item 2").
        and_return("rendered menu!")

      renderer.render_menu(menu_items).should == "rendered menu!"
    end
  end
  
  describe "menu items" do
    before(:each) do
      @template.stub(:current_page?).with("the url").any_number_of_times.and_return(false)
      @renderer = MenuRenderer.new(@template)
    end
  
    it "should generate a link" do
      menu_item = mock("the menu item")
      
      @renderer.should_receive(:content).with(menu_item).and_return("content")
      @renderer.should_receive(:submenu).with(menu_item).and_return("submenu")
      @renderer.should_receive(:css_class).with(menu_item).and_return("css_class")
      @template.should_receive(:content_tag).
        with(:li, ("contentsubmenu").html_safe, :class => "css_class").
        and_return("the list item!")
      
      @renderer.render_item(menu_item).should == "the list item!"
    end
  
    describe "css class" do
      it "should be nil when not active" do
        menu_item = mock("menu item", :submenu_item? => false)
        
        menu_item.should_receive(:active?).with(@template).and_return(false)

        @renderer.css_class(menu_item).should be_nil
      end
      
      it "should be 'current' when active" do
        menu_item = mock("menu item", :submenu_item? => false)
        
        menu_item.should_receive(:active?).with(@template).and_return(true)
        
        @renderer.css_class(menu_item).should == "current"
      end
      
      it "should be nil when submenu item even when active" do
        menu_item = mock("menu item", :submenu_item? => true)
        
        menu_item.stub(:active?).with(@template).and_return(true)
        
        @renderer.css_class(menu_item).should == nil
      end
    end
    
    describe "submenu generation" do
      it "should be empty string without submenu" do
        menu_item = mock("menu item", :has_submenu? => false)

        menu_item.should_receive(:active?).with(@template).and_return(true)
        
        @renderer.submenu(menu_item).should == ""
      end

      it "should be empty string when not active" do
        menu_item = mock("menu item", :has_submenu? => true)

        menu_item.should_receive(:active?).with(@template).and_return(false)
        
        @renderer.submenu(menu_item).should == ""
      end
      
      it "should be empty string when not active and no submenu" do
        menu_item = mock("menu item", :has_submenu? => false)

        menu_item.should_receive(:active?).with(@template).and_return(false)
        
        @renderer.submenu(menu_item).should == ""
      end
      
      it "should recurse when active and has submenu" do
        submenu_items = mock("submenu items")
        menu_item = mock("menu item", :has_submenu? => true, :submenu_items => submenu_items)
        
        menu_item.should_receive(:active?).with(@template).and_return(true)
        @renderer.should_receive(:render_menu).
          with(submenu_items).and_return("rendered submenu!")
          
        @renderer.submenu(menu_item).should == "rendered submenu!"
      end
    end
    
    describe "content of the menu item" do
      it "should not link when on menu's path" do
        menu_item = mock("menu item", :text => "the text", :path => "the path")
        
        @template.stub_chain(:controller, :request, :fullpath).and_return("the path")

        @renderer.content(menu_item).should == "the text"
      end

      it "should link when not on menu's path" do
        menu_item = mock("menu item", :text => "the text", 
                          :path => "the path", :popup => "popup")
        
        @template.stub_chain(:controller, :request, :fullpath).and_return("not the path")
        @template.should_receive(:link_to).with("the text", "the path", :title => "popup").
          and_return("the linked text!")
          
        @renderer.content(menu_item).should == "the linked text!"
      end
    end
  end
end