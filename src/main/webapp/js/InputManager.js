let addNum = 1;
$(document).ready(function() {
    $('#addData').click(function () {
        $('#inputFields' + addNum.toString()).removeClass('invisible');
        $.ajax({
            url: 'MaxQueNum',
            type: 'POST',
            success: function (maxQueNum) {
                let newQueNum = parseInt(maxQueNum) + addNum;
                $('#inputFields' + addNum.toString()).append(
                    '<input readonly type="text" class="editor queNum new" name="queNum" value="' + newQueNum + '\"/> ' +
                    '<input type="text" class="editor queCode new" name="queCode" placeholder="문제 코드를 입력해주세요."/> ' +
                    '<input type="text" class="editor queTitle new" name="queTitle" placeholder="문제 본문을 입력해주세요."/> ' +
                    '<input type="text" class="editor queAnswer new" name="queAnswer" placeholder="문제 정답을 입력해주세요."/> ' +
                    '<input type="text" class="editor queType new" name="queType" placeholder="문제 타입을 입력해주세요."/> ' +
                    '<button id="deleteQuestion">삭제하기</button>'
                );

                $('#inputFields' + addNum.toString()).after( // inputFields 1개 추가
                    '<div id="inputFields' + (addNum + 1).toString() + '\" class="editorWrap invisible"/>'
                );
                ++addNum;
            }
        });
    });

    $(document).on('change', '.queType', function() { // queType의 값이 객관식이면 옵션 입력창 추가
        if ($(this).val() === '객관식') {
            $(this).after('<input type="text" class="editor queOptions new" name="queOptions" placeholder="옵션을 입력해주세요." />');
        }
    });

    $(document).on('change', '.queType', function() { // 값이 객관식 → 주관식으로 변경되면 동위에 있는 옵션 요소들 삭제
    if ($(this).val() === '주관식') {
        $(this).siblings('.queOptions').remove();
    }
});

    $(document).on('input', '.queOptions', function() { // 옵션에 값이 입력되면 옵션 1개 추가
        if ($(this).val() !== '' && $(this).next('.queOptions').length === 0) {
            $(this).after('<input type="text" class="editor queOptions new" name="queOptions" placeholder="옵션을 입력해주세요." />');
        }
    });

    $(document).on('keydown', 'input', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
        }
    });

    $('#deleteQuestion').click(function (e) {
       e.preventDefault();
       $('form').submit();
    });
});

$(document).ready(function() { // 저장하기 누르면 비어있는 옵션 값들 전부 삭제
    $('#saveSQL').click(function () {
        $('.queOptions').each(function () {
            if ($(this).val() === '') {
                $(this).remove();
            }
        });
        $('form').submit();
    });
});

$(document).on('input', '.editor', function() { // 값이 변경되면 value 속성도 같이 변경
    $(this).attr('value', $(this).val());
});

// 기존에 있던 값이 변경되면 name 속성을 updated* 으로 변경
$(document).on('input', 'input.editor.queCode:not(.new)', function() {
    $(this).attr('name', 'updatedCode');
    $(this).siblings('.queNum').attr('name', 'updatedNum');
    $(this).siblings('.queTitle').attr('name', 'updatedTitle');
    $(this).siblings('.queAnswer').attr('name', 'updatedAnswer');
    $(this).siblings('.queType').attr('name', 'updatedType');
    $(this).siblings('.queOptions').attr('name', 'updatedOptions');
});
$(document).on('input', 'input.editor.queTitle:not(.new)', function() {
    $(this).attr('name', 'updatedTitle');
    $(this).siblings('.queNum').attr('name', 'updatedNum');
    $(this).siblings('.queCode').attr('name', 'updatedCode');
    $(this).siblings('.queAnswer').attr('name', 'updatedAnswer');
    $(this).siblings('.queType').attr('name', 'updatedType');
    $(this).siblings('.queOptions').attr('name', 'updatedOptions');
});
$(document).on('input', 'input.editor.queAnswer:not(.new)', function() {
    $(this).attr('name', 'updatedAnswer');
    $(this).siblings('.queNum').attr('name', 'updatedNum');
    $(this).siblings('.queCode').attr('name', 'updatedCode');
    $(this).siblings('.queTitle').attr('name', 'updatedTitle');
    $(this).siblings('.queType').attr('name', 'updatedType');
    $(this).siblings('.queOptions').attr('name', 'updatedOptions');
});
$(document).on('input', 'input.editor.queType:not(.new)', function() {
    $(this).attr('name', 'updatedType');
    $(this).siblings('.queNum').attr('name', 'updatedNum');
    $(this).siblings('.queCode').attr('name', 'updatedCode');
    $(this).siblings('.queTitle').attr('name', 'updatedTitle');
    $(this).siblings('.queAnswer').attr('name', 'updatedAnswer');
    $(this).siblings('.queOptions').attr('name', 'updatedOptions');
});
$(document).on('input', 'input.editor.queOptions:not(.new)', function() {
    $(this).attr('name', 'updatedOptions');
    $(this).siblings('.queNum').attr('name', 'updatedNum');
    $(this).siblings('.queCode').attr('name', 'updatedCode');
    $(this).siblings('.queTitle').attr('name', 'updatedTitle');
    $(this).siblings('.queAnswer').attr('name', 'updatedAnswer');
    $(this).siblings('.queType').attr('name', 'updatedType');
});

// 삭제하기 누르면 name 속성을 deleted*으로 변경
$(document).on('click', '#deleteQuestion', function() {
    $(this).siblings('.queNum').attr('name', 'deletedNum');
    $(this).siblings('.queCode').attr('name', 'deletedCode');
    $(this).siblings('.queTitle').attr('name', 'deletedTitle');
    $(this).siblings('.queAnswer').attr('name', 'deletedAnswer');
    $(this).siblings('.queType').attr('name', 'deletedType');
    $(this).siblings('.queOptions').attr('name', 'deletedOptions');
    location.href = location.href;
});