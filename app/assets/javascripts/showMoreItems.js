
/*!
 * showMoreItem.js Version:1.0.1
 * @copyright 2020 PeggyHsieh
 * @license MIT (https://github.com/peggy-hsieh/showMoreItems)
 */

var buttonBox = '.button-box'
var loadingSpinner = '.search-spinner'

;(function(factory) {
    if (typeof define === 'function' && define.amd) {
        define(['jquery'], factory);
    } else if (typeof exports !== 'undefined') {
        module.exports = factory(require('jquery'));
    } else {
        factory(jQuery);
    }

}(function($) {
    var ShowMoreItems = window.ShowMoreItems || {};
    ShowMoreItems = (function() {
        var instanceUid = 0;
        function ShowMoreItems(element, settings) {
            $(element).addClass('showMoreItemsList')
            var _ = this, dataSettings;
            var defaults = {
                nowNum:1,
                //getView:0,
                startNum:1,
                afterNum:1,
                original:false,
                moreText:'Show more',
                noMoreText:'No more',
                backMoreText:'Take back',
                responsive:''
            }
            dataSettings = $(element).data('showMoreItems') || {};
            _.defaults = $.extend({}, defaults, settings, dataSettings);
            _.options = $.extend({}, defaults, settings, dataSettings);
            _.registerBreakpoints(element);
            _.init(element);
        }
        return ShowMoreItems;
    }());
    ShowMoreItems.prototype.init = function(element) {
        var _ = this;
        _.sum = $(element).children().length
        _.runData(element, _);
        return false
    };
    ShowMoreItems.prototype.runData = function(element, settings) {
        var _ = this;
        _.goOut=false;
        $(element).children().hide()
        $(element).next(buttonBox).remove()
        _.nowNum =settings.options.nowNum -1
        _.goNum = _.nowNum + settings.options.startNum
        if(_.sum<=settings.options.startNum){
            _.goNum=_.sum;
            _.goOut=true;
        }
        for (var i = _.nowNum; i < _.goNum; i++) {
            $(element).children().eq(i).show()
            _.nowNum+=1;
        }
        if(!_.goOut){
            $(element).after(
                '<div class="button-box p1-75-top"><button class="addListData usa-button--outline dm-btn-base display-block line-height-19px margin-x-auto">' + settings.options.moreText + '</button></div>' +
                '<div class="search-spinner display-none flex-justify-center flex-align-self-center p1-75-top"><i class="fas fa-circle-notch"></i></div>'
            );
        }

        // Only allow one loading spinner to be created at a time
        if ($(element).parent().find(loadingSpinner).length > 1) {
            $(element).parent().find(loadingSpinner).last().remove()
        }
        $(element).next().on('click','.addListData', function(event) {
            $(this).closest('section').find(loadingSpinner).removeClass('display-none');
            $(this).closest('section').find(loadingSpinner).addClass('display-flex');
            $(buttonBox).addClass('display-none');
            _.goNum = _.nowNum + settings.options.afterNum
            if (_.sum <= _.goNum) {
                _.goNum = _.sum
                _.goOut = true
            }

            for (var i = _.nowNum; i < _.goNum; i++) {
                $(element).children().eq(i).show()
                _.nowNum += 1
                $('.addListData').closest('section').find(loadingSpinner).addClass('display-none');
                $(buttonBox).removeClass('display-none');
                // If there are no more practice cards to show, hide the 'No more results' button
                if (_.nowNum === _.sum) {
                    $(buttonBox).addClass('display-none');
                }
            }
            // Truncate the text of the next set of cards
            truncateText();

            if (_.goOut && settings.options.original) {
                $(this).text(settings.options.backMoreText).addClass('original')
            } else if (_.goOut) {
                $(this).text(settings.options.noMoreText)
            }
        });
        $(element).next().on('click','.original', function(event) {
            $(this).removeClass('original');
            _.reflesh($(this));
            return false
        });
    };
    ShowMoreItems.prototype.reflesh = function(element) {
        var _ = this;
        thisE = element.parent().prev();
        element.remove();
        _.registerBreakpoints(element);
        _.init(thisE);
    }

    ShowMoreItems.prototype.registerBreakpoints = function(element) {
        var _ = this;
        if(_.options.responsive){
            ResponsiveArr = _.options.responsive
            //排序
            ResponsiveArr = ResponsiveArr.sort(function (a, b) {
                return a.breakpoint > b.breakpoint ? -1 : 1;
            });
            _.options.responsive = ResponsiveArr
            _.Oindex = -1
            _.Owidth = $(window).width()
            $.each(_.options.responsive, function(index, value) {
                if($(window).width()<=value.breakpoint){
                    _.Oindex= index
                    value = value.settings
                    _.options = $.extend({}, _.options, value);
                }
            });
            $(window).resize(function() {
                run=false
                if($(window).width() <_.Owidth){
                    _.Owidth = $(window).width()
                    $.each(_.options.responsive, function(index, value) {
                        if(_.Owidth<=value.breakpoint && _.Oindex < index){
                            _.Oindex= index
                            value = value.settings
                            _.options = $.extend({}, _.options, _.defaults);
                            _.options = $.extend({}, _.options, value);
                            run=true
                            return _.Oindex
                        }
                    });
                }
                if($(window).width() >_.Owidth){
                    _.Owidth = $(window).width()
                    $.each(ResponsiveArr, function(index, value) {
                        if(_.Owidth>value.breakpoint && _.Oindex > index-1){
                            _.Oindex= index-1
                            if(_.Oindex!=-1){
                                value = ResponsiveArr[index-1].settings
                                _.options = $.extend({}, _.options, _.defaults);
                                _.options = $.extend({}, _.options, value);
                                run=true
                            }else{
                                _.options = $.extend({}, _.options, _.defaults);
                                run=true
                            }
                            return _.Oindex
                        }
                    });
                }
                if(run==true){
                    _.runData(element, _);
                }
                return false
            });
        }
    };
    $.fn.showMoreItems = function() {
        var _ = this,
            opt = arguments[0],
            args = Array.prototype.slice.call(arguments, 1),
            l = _.length,
            i,
            ret;
        for (i = 0; i < l; i++) {
            if (typeof opt == 'object' || typeof opt == 'undefined')
                _[i].showMoreItems = new ShowMoreItems(_[i], opt);
            else
                ret = _[i].showMoreItems[opt].apply(_[i].showMoreItems, args);
            if (typeof ret != 'undefined') return ret;
        }
        return _;
    };
    $( function () {
        if($('[data-showMoreItems="true"]').length){
            selecter =$('[data-showMoreItems="true"]')
            if(selecter.attr('data-showMoreItems')=='true'){
                var settings = {
                    nowNum:1,
                    getView:0,
                    startNum:1,
                    afterNum:1,
                    original:false,
                    moreText:'Show more',
                    noMoreText:'No more',
                    backMoreText:'Take back',
                    responsive:''
                }
                if(selecter.attr('data-nowNum')){
                    settings.nowNum=parseInt(selecter.attr('data-nowNum'))
                }
                if(selecter.attr('data-startNum')){
                    settings.startNum=parseInt(selecter.attr('data-startNum'))
                }
                if(selecter.attr('data-afterNum')){
                    settings.afterNum=parseInt(selecter.attr('data-afterNum'))
                }
                if(selecter.attr('data-original')){
                    settings.original=Boolean(selecter.attr('data-original'))
                }
                if(selecter.attr('data-moreText')){
                    settings.moreText=selecter.attr('data-moreText')
                }
                if(selecter.attr('data-noMoreText')){
                    settings.noMoreText=selecter.attr('data-noMoreText')
                }
                if(selecter.attr('data-backMoreText')){
                    settings.backMoreText=selecter.attr('data-backMoreText')
                }
                if(selecter.attr('data-responsive')){
                    settings.responsive=eval(selecter.attr('data-responsive'))
                }
            }
            $('[data-showMoreItems="true"]').showMoreItems(settings);
        }
    });
}));