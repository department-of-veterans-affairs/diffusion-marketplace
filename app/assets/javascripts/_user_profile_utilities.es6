class ProfileEditor {
  constructor() {
    this.$document = $(document);
    this.$deleteBtn = $('.dm-cropper-delete-image');
    this.$imgsContainer = $('.dm-cropper-images-container');
    this.$placeholderImg = $('.cropper-image-placeholder');
    this.workIndex = 0;

    this.initialize();
  }

  initialize() {
    this.setEventListeners();
    this.initializeWorkEntries();
    this.repositionAddWorkEntryButton();
  }

  setEventListeners() {
    this.$document.on('turbolinks:load', () => this.loadProfileFunctions());
    $('form').on('submit', (event) => this.validateAllWorkFields(event));
    $('.dm-cropper-upload-image').on('change', (event) => this.handleImageUpload(event));
    this.$deleteBtn.on('click', (event) => this.clearUpload(event));
    $('#work_links').on('click', '.remove-work-entry', (event) => this.removeWorkEntryField(event)); // Use arrow function here
    $("#add-work-entry").on("click", (e) => this.addWorkEntryField(e));
  }

  loadProfileFunctions() {
    this.initializeWorkEntries();
    this.attachWorkEntryEventListeners();
  };

  validateAllWorkFields(event) {
    let isValid = true;

    $('#work_links .work-entry').each((index, entry) => {
      const textInput = $(entry).find('input[name*="[text]"]')[0];
      const linkInput = $(entry).find('input[name*="[link]"]')[0];

      if (
        textInput && textInput.value.trim() === '' &&
        linkInput && linkInput.value.trim() === ''
      ) {
        return;
      }

      if (textInput) {
        this.validateTextInput({ target: textInput });
        if (!textInput.checkValidity()) {
          textInput.reportValidity();
          isValid = false;
        }
        $(textInput).on('input', () => {
          textInput.setCustomValidity('');
          linkInput.setCustomValidity('');
        });
      }

      if (linkInput) {
        this.validateLinkInput({ target: linkInput });
        if (!linkInput.checkValidity()) {
          linkInput.reportValidity();
          isValid = false;
        }
        $(linkInput).on('input', () => {
          textInput.setCustomValidity('');
          linkInput.setCustomValidity('');
        });
      }
    });

    if (!isValid) {
      event.preventDefault();
    }
  }

  validateTextInput(event) {
    const textInput = event.target;
    textInput.setCustomValidity(textInput.value.trim() === '' ? 'Required' : '');
  }

  validateLinkInput(event) {
    const linkInput = event.target;
    if (linkInput.value.trim() === '') {
      linkInput.setCustomValidity('Required')
    } else {
      linkInput.setCustomValidity(this.isValidURL(linkInput.value) ? '' : 'Please enter a valid URL, e.g., https://example.com');
    }
  }

  isValidURL(string) {
    const pattern = /^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.(com|org|net|gov|edu|io|co|us|uk|biz|info|me)(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?$/i;
    return pattern.test(string);
  }

  handleImageUpload(event) {
    const uploadedImg = event.target.files[0];
    const imgSizeMb = uploadedImg.size * 0.000001; // Convert bytes to MB
    if (imgSizeMb <= 32) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const imgHtml = `<img src="${e.target.result}" class="avatar-profile-photo" alt=""/>`;
        this.$imgsContainer.empty().append(imgHtml);
        $('.dm-image-error-text').addClass('hidden');
        this.toggleDeleteBtn(true, event.target);
        this.$placeholderImg.addClass('display-none');
      };
      reader.readAsDataURL(uploadedImg);
    } else {
      this.$imgsContainer.empty();
      $('.dm-image-error-text').removeClass('hidden').find('p').text('Image exceeds 32MB limit.');
      this.clearUpload(event.target);
    }
  }

  clearUpload(event) {
    event.preventDefault();

    this.$imgsContainer.empty();
    const $fileInput = $(".dm-cropper-upload-image");

    const $newFileInput = $fileInput.clone().val("");
    $fileInput.replaceWith($newFileInput);
    $newFileInput.on('change', (event) => this.handleImageUpload(event));
    this.$placeholderImg.removeClass('display-none');
    this.toggleDeleteBtn(false);
  }

  toggleDeleteBtn(visible, target) {
    const imgDeleteBtn = $(target).closest('.dm-cropper-boundary').find(this.$deleteBtn);
    if (visible) {
      imgDeleteBtn.removeClass('hidden');
    } else {
      imgDeleteBtn.addClass('hidden');
    }
  }

  addWorkEntryField(e) {
    if (e) e.preventDefault();
    const newWorkEntryHtml = `
      <div class="work-entry margin-bottom-2" data-index="${this.workIndex}">
        <label for="user_work_${this.workIndex}_text" class="usa-label">Text</label>
        <input type="text" name="user[work][${this.workIndex}][text]" id="user_work_${this.workIndex}_text" class="usa-input margin-bottom-1" placeholder="e.g., Project Name">

        <label for="user_work_${this.workIndex}_link" class="usa-label">Link</label>
        <input type="text" name="user[work][${this.workIndex}][link]" id="user_work_${this.workIndex}_link" class="usa-input margin-bottom-1" placeholder="e.g., https://example.com">

        <button type="button" class="remove-work-entry usa-button usa-button--unstyled">Remove</button>
      </div>
    `;
    $("#work_links").append(newWorkEntryHtml);

    this.workIndex++;
    this.repositionAddWorkEntryButton();
  }

  removeWorkEntryField(event) {
    event.preventDefault();
    $(event.target).closest(".work-entry").remove();
    if ($("#work_links .work-entry").length === 0) {
      this.addWorkEntryField();
    }
    this.repositionAddWorkEntryButton();
  }

  repositionAddWorkEntryButton() {
    let addButton = $("#add-work-entry");
    if (addButton.length === 0) {
      addButton = $('<button type="button" id="add-work-entry" class="margin-left-1 usa-button usa-button--unstyled">Add Another Work Link</button>');
      addButton.on("click", (e) => this.addWorkEntryField(e));
    }
    $("#work_links .work-entry").last().find(".remove-work-entry").after(addButton);
  }

  initializeWorkEntries() {
    const existingEntries = $("#work_links .work-entry").length;
    this.workIndex = existingEntries; // Start from the correct index

    if (existingEntries === 0) {
      this.addWorkEntryField();
    }
  }
}

$(document).on('turbolinks:load', () => new ProfileEditor());
