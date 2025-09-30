from modeltranslation.translator import translator, TranslationOptions
from kongo_moderation.models import ModerationCategory


class ModerationCategoryTranslationOptions(TranslationOptions):
    fields = ('description', 'title')


translator.register(ModerationCategory, ModerationCategoryTranslationOptions)
