module ScreenShot

  def screenshot(label)

    if label

      page.driver.render("#{ScreenshotPath}#{label}.png")

      "#{ScreenshotPath}#{label}.png"

    end

  end

end
