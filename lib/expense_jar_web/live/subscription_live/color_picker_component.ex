defmodule ExpenseJarWeb.SubscriptionLive.ColorPickerComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  alias Phoenix.HTML.Form

  def render(assigns) do
    ~L"""
    <div
    class="relative mr-4"
    x-data="{
      isOpen: false,
      colors: ['#2196F3', '#009688', '#9C27B0', '#FFEB3B', '#afbbc9', '#4CAF50', '#2d3748', '#f56565', '#ed64a6'],
      colorSelected: '#2196F3'
    }"
    x-init="colorSelected = '<%= Form.input_value(@form, :color) || '#2196F3' %>'"
    >
      <%= Form.hidden_input @form, :color, readonly: true, "x-model": "colorSelected" %>
      <button
        type="button"
        @click="isOpen = !isOpen"
        class="rounded-full focus:outline-none focus:shadow-outline inline-flex p-2 text-lg shadow"
        :style="`background: ${colorSelected}; color: white`"
      >
        <span class="iconify" data-icon="heroicons-outline:color-swatch" data-inline="false"></span>
      </button>
      <div
        x-show="isOpen"
        @click.away="isOpen = false"
        x-transition:enter="transition ease-out duration-100 transform"
        x-transition:enter-start="opacity-0 scale-95"
        x-transition:enter-end="opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75 transform"
        x-transition:leave-start="opacity-100 scale-100"
        x-transition:leave-end="opacity-0 scale-95"
        class="origin-top-left absolute left-0 mt-2 w-40 rounded-md shadow-lg"
      >
        <div class="rounded-md bg-white shadow-xs px-4 py-3">
          <div class="flex flex-wrap -mx-2">
            <template x-for="(color, index) in colors" :key="index">
              <div class="px-2">
                <template x-if="colorSelected === color">
                  <div
                    class="w-8 h-8 inline-flex rounded-full cursor-pointer border-4 shadow"
                :style="`background: ${color};`"
              ></div>
                </template>
                <template x-if="colorSelected != color">
                  <div
                @click="colorSelected = color"
                    @keydown.enter="colorSelected = color"
                    role="checkbox"
                    tabindex="0"
                    :aria-checked="colorSelected"
                    class="w-8 h-8 inline-flex rounded-full cursor-pointer border-4 border-white focus:outline-none focus:shadow-outline"
                    :style="`background: ${color};`"
                  ></div>
                </template>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
